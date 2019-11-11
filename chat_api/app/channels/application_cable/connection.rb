module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
 
    def connect
      print "\nCOOKIES\n"
      print User.find_by(name: "Prueba")
      print "\n"

      self.current_user = find_verified_user
    end
 
    private
      def find_verified_user
        if verified_user = User.find_by(name: "Prueba")
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end