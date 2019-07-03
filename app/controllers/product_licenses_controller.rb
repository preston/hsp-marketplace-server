class ProductLicensesController < ApplicationController

	load_and_authorize_resource	:product
	load_and_authorize_resource	:product_license

	def index
      @product_licenses = ProductLicense.paginate(page: params[:page], per_page: params[:per_page]).where(product_id: @product)
    #   sort = %w{user_id product_license_id valid_from}.include?(params[:sort]) ? params[:sort] : :valid_from
    #   order = 'asc' == params[:order] ? :asc : :desc # Descending by default.
    #   @entitlements = @entitlements.order(sort => order).joins(product_license: [:product, :license])
    #   @entitlements.joins(product_license: [:product, :license]).all
    end


    def show
    end

    def create
        @product_license = ProductLicense.new(product_license_params)
        respond_to do |format|
            if @product_license.save
                format.json { render :show, status: :created, location: product_license_path(@product_license.product, @product_license) }
            else
                format.json { render json: @product_license.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @product_license.update(product_license_params)
                format.json { render :show, status: :ok, location: product_license_path(@product_license.product, @product_license) }
            else
                format.json { render json: @product_license.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @product_license.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_license_params
        # params.require(:product_license).permit(:account_id, :name, :description)
        params.require(:product_license).permit(:product_id, :license_id)
      end
end
