class ScreenshotsController < ApplicationController

    load_and_authorize_resource	:service
    load_and_authorize_resource	:screenshot

    def index
        @screenshots = Screenshot.all
    end

    def show; end

    def create
        @screenshot = Screenshot.new(screenshot_params)
		# debugger
        respond_to do |format|
            if @screenshot.save
                format.json { render :show, status: :created, location: service_screenshot_url(@service, @screenshot) }
            else
                format.json { render json: @screenshot.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @screenshot.update(screenshot_params)
                format.json { render :show, status: :ok, location: service_screenshot_url(@service, @screenshot) }
            else
                format.json { render json: @screenshot.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @screenshot.destroy
        respond_to do |format|
            format.json { head :no_content }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def screenshot_params
        params.require(:screenshot).permit(:service_id, :caption, :image)
    end
end
