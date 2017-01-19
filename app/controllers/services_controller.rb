class ServicesController < ApplicationController

    load_and_authorize_resource

    # GET /services
    # GET /services.json
    def index
        @services = Service.all
    end

	def search
		@services = []
		@services = Service.search_by_name_or_description(params['text']) if params['text']
		puts "LENGTH: #{@services.length}"
		render :index
	end

    # GET /services/1
    # GET /services/1.json
    def show; end

    # POST /services
    # POST /services.json
    def create
        @service = Service.new(service_params)
        respond_to do |format|
            if @service.save
                format.json { render :show, status: :created, location: @service }
            else
                format.json { render json: @service.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /services/1
    # PATCH/PUT /services/1.json
    def update
        respond_to do |format|
            if @service.update(service_params)
                format.json { render :show, status: :ok, location: @service }
            else
                format.json { render json: @service.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /services/1
    # DELETE /services/1.json
    def destroy
        @service.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_service
        @service = Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
        params.require(:service).permit(:name, :description, :user_id, :uri, :support_url, :license_id, :logo, :approved_at, :visible_at)
    end
end
