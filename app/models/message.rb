# app/models/message.rb
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :feature_key, type: String
  field :content, type: String
  field :output_tokens, type: Integer
  field :input_tokens, type: Integer
  field :conversation_id, type: String
  field :user_id, type: Integer
  field :request_id, type: String

  index({ conversation_id: 1 })
  index({ user_id: 1 })
  
end
