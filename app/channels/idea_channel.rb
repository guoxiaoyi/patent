class IdeaChannel < ApplicationCable::Channel
  def subscribed
    @conversation = Conversation.find_by(id: params[:conversation_id])
    if @conversation && @conversation.user_id == current_user.id
      stream_from "idea_channel_#{@conversation.id}"
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
end
