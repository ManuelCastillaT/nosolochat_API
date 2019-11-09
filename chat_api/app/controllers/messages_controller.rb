class MessagesController < ApplicationController
    before_action :authorize_access_request!

    def create
        chatroom = Chatroom.find_by(name: params[:message][:chatroom_name])

        if chatroom
            user = User.find(payload['user_id'])

            if user
                message = Message.new(text: params[:message][:text], owner_name: user.name)

                chatroom.messages << message

                if message.save
                    render json: message, status: :created
                else
                    render json: message.errors, status: :unprocessable_entity
                end
            else
                render json: message.errors, status: :unprocessable_entity
            end
        else
            render json: message.errors, status: :unprocessable_entity
        end
    end
end
