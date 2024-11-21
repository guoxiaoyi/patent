class Feature < ApplicationRecord
  has_many :transactions, as: :transactionable, dependent: :destroy
  has_many :conversations
  has_many :sub_features, dependent: :destroy
  accepts_nested_attributes_for :sub_features, allow_destroy: true

  enum feature_key: { innovate: 0, write_application: 1 }
  # Feature keys:
  # - innovate: 挖掘创新点
  # - write_application: 撰写申请书
  #   -> patent_title                   标题
  #   -> technical_field                技术领域
  #   -> background_art                 技术背景
  #   -> claims                         权利要求书
  #   -> abstract                       摘要
  #   -> invention_summary              发明内容
  #   -> detailed_description           具体实施方式


  # 返回树状结构
  def self.to_tree
    all.includes(:sub_features).map do |feature|
      {
        id: feature.id,
        name: feature.feature_key,
        prompt: feature.prompt,
        sub_features: feature.sub_features.map do |sub_feature|
          { 
            id: sub_feature.id,
            name: sub_feature.feature_key,
            order: sub_feature.sort_order,
            prompt: sub_feature.prompt
          }
        end
      }
    end
  end

  def use(conversation)
    method_name = "#{feature_key}_logic"  # 动态生成方法名
    if respond_to?(method_name, true)     # 检查是否存在该方法
      send(method_name, conversation)                   # 动态调用相应的方法
    else
      default_logic(conversation)                       # 如果方法不存在，调用默认逻辑
    end
  end

  # 挖掘创新点
  def innovate_logic(conversation)
    InnovateConversationJob.perform_later(conversation, conversation.user)
  end

  # 撰写申请书
  def write_application_logic(conversation)
    conversation.update!(processing: true)
    conversation.dispatch_pending_steps
  end

  def analyze_system_logic(conversation)
    "This is the analyze_system logic."
  end

  # 当 feature_key 对应的方法不存在时调用
  def default_logic(conversation)
    Rails.logger.warn("No logic defined for feature_key: #{feature_key}")
  end

end
