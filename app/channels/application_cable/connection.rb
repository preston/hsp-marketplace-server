module ApplicationCable
    class Connection < ActionCable::Connection::Base
        identified_by :current_user

        def connect
            self.current_user = find_verified_user
        end

        private

        def find_verified_user
            puts "Identity ID: #{cookies.signed['identity_id']}"
            if cookies.signed['identity_id']
                Identity.find(cookies.signed['identity_id']).user
            # if current_user = User.find_by(id: cookies.signed[:user_id])
            #     current_user
            else
                reject_unauthorized_connection
            end
        end
      end
end
