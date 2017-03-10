module ApplicationCable
    class Connection < ActionCable::Connection::Base
        identified_by :current_user

        def connect
            self.current_user = find_verified_user
        end

        private

        def find_verified_user
            puts "Identity ID: #{cookies.signed['identity_id']}"
            # byebug
            if cookies.signed['identity_id']
                Identity.find(cookies.signed['identity_id']).user
            # if current_user = User.find_by(id: cookies.signed[:user_id])
            #     current_user
            elsif platform_id = request.params['platform_id']
                puts "Platform ID: #{platform_id}"
                puts "JWT: #{request.params[:jwt]}"
                # reject_unauthorized_connection # FIXME
            else
                # reject_unauthorized_connection # FIXME
            end
        end
      end
end
