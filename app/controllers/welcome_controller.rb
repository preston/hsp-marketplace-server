class WelcomeController < ApplicationController

    def dashboard
    end

    def status
        render status: :ok
    end

end
