class BuildsController < ApplicationController

    load_and_authorize_resource	:service
    load_and_authorize_resource

    # GET /builds
    # GET /builds.json
    def index
        @builds = @service.builds
    end

    # GET /builds/1
    # GET /builds/1.json
    def show; end

    # POST /builds
    # POST /builds.json
    def create
        @build = Build.new(build_params)

        respond_to do |format|
            if @build.save
                format.json { render :show, status: :created, location: service_build_url(@service, @build) }
            else
                format.json { render json: @build.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /builds/1
    # PATCH/PUT /builds/1.json
    def update
        respond_to do |format|
            if @build.update(build_params)
                format.json { render :show, status: :ok, location: service_build_url(@service, @build) }
            else
                format.json { render json: @build.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /builds/1
    # DELETE /builds/1.json
    def destroy
        @build.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_build
        @build = Build.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_params
        params.require(:build).permit(:id, :service_id, :service_version, :version, :container_respository_url, :container_tag, :validated_at, :published_at, :permissions, :release_notes)
    end
end
