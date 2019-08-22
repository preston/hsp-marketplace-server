class BuildsController < ApplicationController

    load_and_authorize_resource	:product
    load_and_authorize_resource

    def index
        # @builds = @product.builds
		@builds = Build.where(product: @product).paginate(page: params[:page], per_page: params[:per_page])
		sort = %w(version).include?(params[:sort]) ? params[:sort] : :version
		order = 'desc' == params[:order] ? :desc : :asc
		@builds = @builds.order(sort => order)
		@builds = @builds.search_by_version(params[:version]) if params[:version]

    end

    def show; end

    def asset
        response.headers["Content-Type"] = @build.asset.content_type
        response.headers["Content-Disposition"] = "attachment; #{@build.asset.filename}"
        @build.asset.blob.download do |chunk|
            response.stream.write(chunk)
        end
    end

    def create
        @build = Build.new(build_params)

        respond_to do |format|
            if @build.save
                format.json { render :show, status: :created, location: product_build_url(@product, @build) }
            else
                format.json { render json: @build.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @build.update(build_params)
                format.json { render :show, status: :ok, location: product_build_url(@product, @build) }
            else
                format.json { render json: @build.errors, status: :unprocessable_entity }
            end
        end
    end

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
        params.require(:build).permit(:id, :product_id, :version, :container_repository, :container_tag, :validated_at, :published_at, :permissions, :release_notes)
    end

end
