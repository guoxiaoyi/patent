class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  def connect
    console.log("Connected to Actioncable")
  end

  def disconnected
    # Logic when a client disconnects from the channel
  end

  def received(data)
    # Logic when a client receives data from the channel
  end
end
