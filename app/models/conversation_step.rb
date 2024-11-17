class ConversationStep < ApplicationRecord
  acts_as_paranoid

  belongs_to :conversation
  belongs_to :sub_feature

  enum status: { pending: 0, processing: 1, completed: 2, failed: 3 }

  default_scope { includes(:sub_feature).order('sub_features.sort_order') }
  
  scope :pending, -> { where(status: [:pending, :failed]) }


  after_update :check_and_update_conversation_processing

  # 返回第一组待执行的步骤
  def self.standby
    # 检查是否有任何 processing 状态的步骤
    processing_step = where(status: :processing).exists?

    # 如果有正在执行的步骤，返回空
    return [] if processing_step

    # 获取所有状态为 pending 或 failed 的步骤，并按 sort_order 分组
    grouped_steps = where(status: [:pending, :failed]).group_by { |step| step.sub_feature.sort_order }

    # 返回第一个待执行的组（sort_order 最小的）
    first_group = grouped_steps.first
    first_group ? first_group.last : []  # 返回第一组的步骤，若没有则返回空数组
  end

  private

  # 检查并更新 conversation 的 processing 状态
  def check_and_update_conversation_processing
    if conversation.steps.where.not(status: :completed).empty?
      conversation.update!(processing: false)
      Rails.logger.info "All steps completed for Conversation #{conversation.id}. Processing set to false."
    end
  end
  
end
