class PlatformsController < ApplicationController
    load_and_authorize_resource
    load_and_authorize_resource :user

    def index
        @platforms = Platform.paginate(page: params[:page], per_page: params[:per_page])
    end

    def show; end

    def create
        @platform = Platform.new(platform_params)
        respond_to do |format|
            if @platform.save
                format.json { render :show, status: :created, location: user_platform_url(@platform.user, @platform) }
            else
                format.json { render json: @platform.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @platform.update(platform_params)
                format.json { render :show, status: :ok, location: user_platform_url(@platform.user, @platform) }
            else
                format.json { render json: @platform.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @platform.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_platform
        @platform = Platform.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def platform_params
        params.require(:platform).permit(:id, :name, :user_id, :public_key)
    end
end
