class WelcomeController < ApplicationController

    def dashboard; end

    def status
		# puts "SESSION: #{} #{@current_identity}"
		# session.inspect
		# debugger
        render status: :ok
    end

end
