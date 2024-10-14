# app/models/conversation_history.rb
class ConversationHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :conversation_id, type: String
  field :user_id, type: String
  field :content, type: String
  field :tokens, type: Integer
  field :message_type, type: String # 用于存储消息类型

  # 索引设置
  index({ conversation_id: 1 })
  index({ user_id: 1 })
  index({ message_type: 1 })
  index({ created_at: 1 })

  # 可选: 如果需要自动删除旧数据，可以设置 TTL
  # index({ created_at: 1 }, { expire_after_seconds: 30.days.to_i })

  # 可选：添加枚举类型限制
  MESSAGE_TYPES = %w[text image audio video].freeze

  validates :message_type, inclusion: { in: MESSAGE_TYPES }
end
