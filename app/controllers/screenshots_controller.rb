class ScreenshotsController < ApplicationController
    skip_before_action	:authenticate_identity!, only: [:index, :show]
    load_and_authorize_resource	:service
    load_and_authorize_resource	:build
    load_and_authorize_resource	:screenshot

    # GET /screenshots
    # GET /screenshots.json
    def index
        @screenshots = Screenshot.all
    end

    # GET /screenshots/1
    # GET /screenshots/1.json
    def show; end

    # POST /screenshots
    # POST /screenshots.json
    def create
        @screenshot = Screenshot.new(screenshot_params)

        respond_to do |format|
            if @screenshot.save
                format.html { redirect_to @screenshot, notice: 'Screenshot was successfully created.' }
                format.json { render :show, status: :created, location: @screenshot }
            else
                format.html { render :new }
                format.json { render json: @screenshot.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /screenshots/1
    # PATCH/PUT /screenshots/1.json
    def update
        respond_to do |format|
            if @screenshot.update(screenshot_params)
                format.html { redirect_to @screenshot, notice: 'Screenshot was successfully updated.' }
                format.json { render :show, status: :ok, location: @screenshot }
            else
                format.html { render :edit }
                format.json { render json: @screenshot.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /screenshots/1
    # DELETE /screenshots/1.json
    def destroy
        @screenshot.destroy
        respond_to do |format|
            format.html { redirect_to screenshots_url, notice: 'Screenshot was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_screenshot
        @screenshot = Screenshot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def screenshot_params
        params.require(:screenshot).permit(:build_id, :caption, :mime_type, :data)
    end
end
