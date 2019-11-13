class RefreshController < ApplicationController
    before_action :authorize_refresh_by_access_request!
  
    def create
      session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
      tokens  = session.refresh_by_access_payload

      tokenID = JWT.encode({
        'user_id': payload['user_id'],
      }, "nosolosoftware", algorithm='HS256')

      response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:csrf],
                        httponly: true,
                        secure: Rails.env.production?)

      render json: { login: tokens, token_id: tokenID }
    end
  end