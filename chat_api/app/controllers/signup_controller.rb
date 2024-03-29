class SignupController < ApplicationController
 
  def create
    user = User.new(user_params)
    if user.save
      payload  = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      tokenID = JWT.encode(user.id, "nosolosoftware", algorithm='HS256')

      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:csrf],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { login: tokens, token_id: tokenID }
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:signup).permit(:name, :password)
  end
end