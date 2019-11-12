class RoomChannel < ApplicationCable::Channel
  
  def subscribed
    stream_from "chat_" + params[:chatroom_name]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
