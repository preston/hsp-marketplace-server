class ServicesController < ApplicationController
    load_and_authorize_resource

    def index
        @services = Service.paginate(page: params[:page], per_page: params[:per_page])
        sort = %w(name description).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @services = @services.order(sort => order)
		if params['published'] == 'true'
            @services = @services.where('published_at IS NOT NULL')
        elsif params['published'] == 'false'
            @services = @services.where('published_at IS NULL')
        end
		if params['license_id']
            @services = @services.where(license_id: params['license_id'])
        end
		if params['user_id']
            @services = @services.where(user_id: params['user_id'])
        end
        @services = @services.search_by_name(params[:name]) if params[:name]
    end

    def search
        @services = []
        @services = Service.paginate(page: params[:page], per_page: params[:per_page])
        @services = @services.search_by_name_or_description(params['text']) if params['text']
        if params['published'] == 'true'
            @services = @services.where('published_at IS NOT NULL')
        elsif params['published'] == 'false'
            @services = @services.where('published_at IS NULL')
        end
        # puts "LENGTH: #{@services.length}"
        render :index
    end

    def small
        send_image_data(:small)
    end

    def medium
        send_image_data(:medium)
  end

    def large
        send_image_data(:large)
    end

    def publish
        @service.update(published_at: Time.now)
        render :show
     end

    def unpublish
        @service.update(published_at: nil)
        render :show
     end

    def send_image_data(size)
        send_data @service.logo.file_for(size).file_contents, type: @service.logo.content_type, disposition: 'inline'
    end

    # GET /services/1
    # GET /services/1.json
    def show; end

    # POST /services
    # POST /services.json
    def create
        @service = Service.new(service_params)
        # byebug
        if service_params['logo'].nil?
            @service.logo = File.open(File.join(Rails.root, 'public', 'placeholder_logo.png'))
            # puts "LOGO: " + @service.logo
        end
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
        params.require(:service).permit(:name, :description, :user_id, :uri, :support_url, :license_id, :logo, :published_at, :visible_at)
    end
end
