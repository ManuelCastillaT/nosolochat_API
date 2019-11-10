Rails.application.routes.draw do
  post 'refresh',   controller: :refresh, action: :create
  post 'signin',    controller: :signin, action: :create
  post 'signup',    controller: :signup, action: :create
  delete 'signin',  controller: :signin, action: :destroy
  post 'chatrooms', controller: :chatrooms, action: :create
  get 'chatrooms',  controller: :chatrooms, action: :index
  get '/chatrooms/:name', controller: :chatrooms, action: :show
  post 'messages',  controller: :messages, action: :create

  mount ActionCable.server, at: '/cable'
end
