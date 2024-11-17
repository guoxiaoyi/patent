# app/models/message.rb
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :feature_key, type: String
  field :sub_feature_key, type: String
  field :content, type: String
  field :output_tokens, type: Integer
  field :input_tokens, type: Integer
  field :conversation_id, type: Integer
  field :user_id, type: Integer
  field :request_id, type: String

  index({ conversation_id: 1, feature_key: 1, sub_feature_key: 1 })
  index({ user_id: 1 })

end
