module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
 
    def connect
      token = request.params[:token]
      print "\nTOKEN\n"
      print token
      print "\n\n"

      decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]

      print "\nCOOKIES\n"
      print decoded
        # cookies.each do |key, value|
        #   puts "#{key}:#{value}"
      #end
      print "\n\n"
      self.current_user = find_verified_user
    end
 
    private
      def find_verified_user
        if verified_user = User.find_by(name: cookies.signed[:user_id])
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end