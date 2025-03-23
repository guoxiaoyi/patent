# app/models/conversation.rb
class Conversation < ApplicationRecord
  acts_as_paranoid

  include Messageable  

  belongs_to :user
  belongs_to :feature
  belongs_to :tenant
  

  has_many :steps, class_name: 'ConversationStep', foreign_key: 'conversation_id', dependent: :destroy

  before_create :generate_uuid
  # 添加 after_commit 回调，在会话创建后自动创建步骤
  after_commit :create_conversation_steps, on: :create
  # 在创建前生成 UUID 和检查 user 是否可以使用 feature
  validates :feature, presence: true  # 验证 feature 必须存在
  validate :check_user_can_use_feature, on: :create, if: -> { feature.present? }  # 仅当 feature 存在时才验证

  def processing?
    self.processing
  end

  def download
    # 假设 `messages` 是 Conversation 模型中的方法
    messages = self.messages.where(feature_key: feature.feature_key)

    template = Rails.root.join('config', 'templates', 'custom-template.docx')

    # 1. 将 Markdown 转换为 HTML 并保存
    html_content = "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body>"

    messages.each do |msg|
      key = msg['sub_feature_key']
      markdown_content = msg['content']
      html_fragment = PandocRuby.convert(markdown_content, from: :markdown, to: :html)

      html_content += "<h2 style='page-break-before: always;'>#{SubFeature.find_by(feature_key: key).name.chars.join('&nbsp;&nbsp;&nbsp;')}</h2>"
      html_content += html_fragment
    end

    html_content += "</body></html>"

    # 保存 HTML 文件
    html_path = Rails.root.join('tmp', "exported_content_#{Time.now.to_i}.html")
    File.write(html_path, html_content, encoding: 'UTF-8')
    puts "生成的 HTML 文件路径：#{html_path}"

    # 2. 使用 Pandoc 命令将 HTML 转换为 Word
    word_path = Rails.root.join('tmp', "exported_content_#{Time.now.to_i}.docx")
    
    # 调试信息: 打印 Pandoc 命令
    command = "pandoc #{html_path} -o #{word_path} --reference-doc=#{template}"
    puts "正在执行命令: #{command}"
    system(command)

    # 确认 Word 文件是否生成
    unless File.exist?(word_path)
      puts "生成 Word 文件失败，请检查 Pandoc 设置。"
      return
    end

    # 3. 删除 HTML 文件，仅保留生成的 Word 文件
    # FileUtils.rm(html_path)
    puts "生成的 Word 文件路径：#{word_path}"

    word_path
  end

  def check_docx_file(file_path)
    begin
      Zip::File.open(file_path) do |zip_file|
        zip_file.each do |entry|
          puts "Found entry: #{entry.name}"  # 输出每个文件条目的名称
        end
      end
    rescue Zip::Error => e
      puts "解压文件时遇到错误: #{e.message}"
    end
  end

  # 测试该文件
  

  def dispatch_pending_steps
    steps.standby.each do |step|
      # 动态构建并调度相应的 Job
      job_class = "SubFeatures::#{step.sub_feature.feature_key.camelize}Job".constantize
      job_class.perform_later(self, step)
    end
  end

  def reset
    steps.update_all(status: :pending)
    messages.destroy_all
    update(processing: false)
  end
  
  private

  def generate_uuid
    self.request_id = SecureRandom.uuid if self.request_id.blank?
  end
  # 检查用户是否能使用 feature
  def check_user_can_use_feature
    unless user.use_feature(self)  # 如果返回 false 则中止创建
      errors.add(:base, "User is not allowed to use this feature")
    end
  end

  def create_conversation_steps
    sub_features = feature.sub_features.order(:sort_order)
    steps.create(feature.sub_features.map{ |item| {sub_feature: item, status: 'pending' }})
  end
end
