class SubProductsController < ApplicationController
  before_action :set_sub_product, only: [:show, :edit, :update, :destroy]

  # GET /sub_products
  # GET /sub_products.json
  def index
    @sub_products = SubProduct.all
  end

  # GET /sub_products/1
  # GET /sub_products/1.json
  def show
  end

  # GET /sub_products/new
  def new
    @sub_product = SubProduct.new
  end

  # GET /sub_products/1/edit
  def edit
  end

  # POST /sub_products
  # POST /sub_products.json
  def create
    @sub_product = SubProduct.new(sub_product_params)

    respond_to do |format|
      if @sub_product.save
        format.html { redirect_to @sub_product, notice: 'Sub product was successfully created.' }
        format.json { render :show, status: :created, location: @sub_product }
      else
        format.html { render :new }
        format.json { render json: @sub_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_products/1
  # PATCH/PUT /sub_products/1.json
  def update
    respond_to do |format|
      if @sub_product.update(sub_product_params)
        format.html { redirect_to @sub_product, notice: 'Sub product was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_product }
      else
        format.html { render :edit }
        format.json { render json: @sub_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_products/1
  # DELETE /sub_products/1.json
  def destroy
    @sub_product.destroy
    respond_to do |format|
      format.html { redirect_to sub_products_url, notice: 'Sub product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_product
      @sub_product = SubProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_product_params
      params.require(:sub_product).permit(:parent_id, :child_id)
    end
end
