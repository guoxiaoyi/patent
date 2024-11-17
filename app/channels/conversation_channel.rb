class ConversationChannel < ApplicationCable::Channel
  def subscribed
    if conversation && conversation.user_id == current_user.id
      stream_from "conversation_channel_#{conversation.request_id}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  def connected
    p '12312312'
  end

  def disconnected
    # Logic when a client disconnects from the channel
  end

  def received(data)
    # Logic when a client receives data from the channel
  end

  private
  # 缓存 @conversation，确保只查询一次
  def conversation
    @conversation ||= Conversation.find_by(request_id: params[:conversation_id])
  end
end
