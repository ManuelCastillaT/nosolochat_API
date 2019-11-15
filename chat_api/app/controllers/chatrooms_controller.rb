class ChatroomsController < ApplicationController
  before_action :authorize_access_request!, except: [:show, :index]

  def create
    chatroom = Chatroom.find_by(name: params[:chatroom][:name])
    if chatroom
        render json: chatroom.errors, status: :already_exists
    else
      chatroom = Chatroom.new(chatroom_params)
      if chatroom.save
        ActionCable.server.broadcast "Chatroom_Index", name:  chatroom.name
        render json: chatroom, status: :created
      else
        render json: chatroom.errors, status: :unprocessable_entity
      end
    end
  end

  def show
    chatroom = Chatroom.find_by(name: params[:name])

    length = chatroom.messages.length

    if length > 0
        if length < 20
            messages = chatroom.messages[-length..-1]
        else
            messages = chatroom.messages[-20..-1]
        end
    else
        messages = {}
    end

    render json: messages
  end

  def index
    chatrooms = Chatroom.all
    render json: chatrooms
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name)
  end
end
