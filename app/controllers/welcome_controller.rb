class WelcomeController < ApplicationController

    # skip_authorization_check

    def landing
        @skip_navigation = true
    end

    def dashboard; end

    def status
		# puts "SESSION: #{} #{@current_identity}"
		# session.inspect
		# debugger
        render status: :ok
    end

end
