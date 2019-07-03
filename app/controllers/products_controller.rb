class ProductsController < ApplicationController
    load_and_authorize_resource

    def index
        @products = Product.paginate(page: params[:page], per_page: params[:per_page])
        sort = %w(name description).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @products = @products.order(sort => order)
		if params['published'] == 'true'
            @products = @products.where('published_at IS NOT NULL')
        elsif params['published'] == 'false'
            @products = @products.where('published_at IS NULL')
        end
		if params['license_id']
            @products = @products.where(license_id: params['license_id'])
        end
		if params['user_id']
            @products = @products.where(user_id: params['user_id'])
        end
        @products = @products.search_by_name(params[:name]) if params[:name]
    end

    def search
        @products = []
        @products = Product.paginate(page: params[:page], per_page: params[:per_page])
        @products = @products.search_by_name_or_description(params['text']) if params['text']
        if params['published'] == 'true'
            @products = @products.where('published_at IS NOT NULL')
        elsif params['published'] == 'false'
            @products = @products.where('published_at IS NULL')
        end
        # puts "LENGTH: #{@products.length}"
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
        @product.update(published_at: Time.now)
        render :show
     end

    def unpublish
        @product.update(published_at: nil)
        render :show
     end

    def send_image_data(size)
        send_data @product.logo.file_for(size).file_contents, type: @product.logo.content_type, disposition: 'inline'
    end

    # GET /products/1
    # GET /products/1.json
    def show; end

    # POST /products
    # POST /products.json
    def create
        @product = Product.new(service_params)
        # byebug
        if service_params['logo'].nil?
            @product.logo = File.open(File.join(Rails.root, 'public', 'placeholder_logo.png'))
            # puts "LOGO: " + @product.logo
        end
        respond_to do |format|
            if @product.save
                format.json { render :show, status: :created, location: @product }
            else
                format.json { render json: @product.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /products/1
    # PATCH/PUT /products/1.json
    def update
        respond_to do |format|
            if @product.update(service_params)
                format.json { render :show, status: :ok, location: @product }
            else
                format.json { render json: @product.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /products/1
    # DELETE /products/1.json
    def destroy
        @product.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_service
        @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
        params.require(:product).permit(:name, :description, :external_id, :locale, :user_id, :uri, :support_url, :license_id, :logo, :published_at, :visible_at)
    end
end
