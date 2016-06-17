# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
      def find_verified_user
        current_user = User.find_by(id: cookies.signed['user.id'])
        cookie_not_expired = cookies.signed['user.expires_at'] > Time.now
        
        if current_user && cookie_not_expired
          current_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
