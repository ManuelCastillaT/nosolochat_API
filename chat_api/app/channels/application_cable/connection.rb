module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
 
    def connect
      self.current_user = find_verified_user
    end
 
    private
      def find_verified_user
        token = request.params[:token]

        decoded = JWT.decode(token, "nosolosoftware", algorithms=['HS256'])[0]

        user = User.find(decoded)

        if verified_user = user
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end