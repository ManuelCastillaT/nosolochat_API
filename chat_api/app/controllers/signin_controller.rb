class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by(name: params[:signin][:name])
    if user
      if user.authenticate(params[:signin][:password])
        payload = { user_id: user.id }

        session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)

        tokens = session.login

        response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)

        render json: { login: session.login }
      else
        not_authorized
      end
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload
    render json: :ok
  end

  private

  def not_found
    render json: { error: "Cannot find user/password combination" }, status: :not_found
  end
end