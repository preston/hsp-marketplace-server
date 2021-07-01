# frozen_string_literal: true

class ProductsController < ApplicationController
  load_and_authorize_resource

  def index
    @products = Product.paginate(page: params[:page], per_page: params[:per_page])
    sort = %w[name description].include?(params[:sort]) ? params[:sort] : :name
    order = params[:order] == 'desc' ? :desc : :asc
    @products = @products.order(sort => order)
    @products = @products.where.not(published_at: nil)
    @products = @products.where.not(visible_at: nil)
    # if params['published'] == 'true'
    #   @products = @products.where.not(published_at: nil)
    # elsif params['published'] == 'false'
    #   @products = @products.where(published_at: nil)
    # end
    @products = @products.where(license_id: params['license_id']) if params['license_id']
    @products = @products.where(user_id: params['user_id']) if params['user_id']
    unless params['mime_type'].blank?
      types = params['mime_type'].gsub(' ', '+').split(',')
      @products = @products.where(mime_type: types)
    end
    @products = @products.search_by_name(params[:name]) if params[:name]
  end

  def children
    ids = SubProduct.where(parent_id: @product.id).pluck(:child_id)
    @products = Product.paginate(page: params[:page], per_page: params[:per_page]).where(id: ids).order(name: :asc)
    render :index # , format: :json
  end

  def parents
    ids = SubProduct.where(child_id: @product.id).pluck(:parent_id)
    @products = Product.paginate(page: params[:page], per_page: params[:per_page]).where(id: ids).order(name: :asc)
    render :index
  end

  def search
    @products = []
    @products = Product.paginate(page: params[:page], per_page: params[:per_page])
    @products = @products.search_by_name_or_description(params['text']) if params['text']
    @products = @products.where.not(published_at: nil)
    @products = @products.where.not(visible_at: nil)
    # order = params[:order] == 'desc' ? :desc : :asc
    # @products = @products.order(name: order)
    # if params['published'] == 'true'
    #   @products = @products.where('published_at IS NOT NULL')
    # elsif params['published'] == 'false'
    #   @products = @products.where('published_at IS NULL')
    # end
    unless params['mime_type'].blank?
      types = params['mime_type'].split(',')
      @products = @products.where(mime_type: types)
    end
    # puts "LENGTH: #{@products.length}"
    render :index
  end

  def small
    send_image_data('100x100')
  end

  def medium
    send_image_data('200x200')
  end

  def large
    send_image_data('400x400')
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
    response.headers['Content-Type'] = @product.logo.content_type
    response.headers['Content-Disposition'] = "inline; #{@product.logo.filename}"
    @product.logo.variant(resize: size).blob.download do |chunk|
      response.stream.write(chunk)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    respond_to do |format|
      format.json do
        render :show
        # render json: { message: 'You are not authorized, sorry!' }, status: :unauthorized
      end
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    # byebug
    if product_params['logo'].nil?
      tmp = File.open(File.join(Rails.root, 'public', 'placeholder_logo.png'))
      @product.logo.attach(io: tmp, filename: File.basename(tmp.path))
      tmp.rewind
      # @product.save!
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
      # byebug
      if @product.update(product_params)
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
  def product_params
    params.require(:product).permit(:name, :description, :external_id, :locale, :mime_type, :user_id, :uri,
                                    :support_url, :license_id, :logo, :published_at, :visible_at)
  end
end
