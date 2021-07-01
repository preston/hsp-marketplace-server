class WelcomeController < ApplicationController

    def status
        respond_to do |format|
            format.json { render status: :ok }
        end
    end

end
