class WriteApplicationConversationJob < ApplicationJob
  queue_as :default

  def perform(conversation_id)
    conversation = Conversation.find(conversation_id)
    processor = Features::WriteApplicationProcessor.new(conversation)
    processor.process_sub_features
  end
end
