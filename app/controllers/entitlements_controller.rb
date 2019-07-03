class EntitlementsController < ApplicationController
  before_action :set_entitlement, only: [:show, :edit, :update, :destroy]

  # GET /entitlements
  # GET /entitlements.json
  def index
    @entitlements = Entitlement.all
  end

  # GET /entitlements/1
  # GET /entitlements/1.json
  def show
  end

  # GET /entitlements/new
  def new
    @entitlement = Entitlement.new
  end

  # GET /entitlements/1/edit
  def edit
  end

  # POST /entitlements
  # POST /entitlements.json
  def create
    @entitlement = Entitlement.new(entitlement_params)

    respond_to do |format|
      if @entitlement.save
        format.html { redirect_to @entitlement, notice: 'Entitlement was successfully created.' }
        format.json { render :show, status: :created, location: @entitlement }
      else
        format.html { render :new }
        format.json { render json: @entitlement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entitlements/1
  # PATCH/PUT /entitlements/1.json
  def update
    respond_to do |format|
      if @entitlement.update(entitlement_params)
        format.html { redirect_to @entitlement, notice: 'Entitlement was successfully updated.' }
        format.json { render :show, status: :ok, location: @entitlement }
      else
        format.html { render :edit }
        format.json { render json: @entitlement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entitlements/1
  # DELETE /entitlements/1.json
  def destroy
    @entitlement.destroy
    respond_to do |format|
      format.html { redirect_to entitlements_url, notice: 'Entitlement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entitlement
      @entitlement = Entitlement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entitlement_params
      params.require(:entitlement).permit(:user_id, :product_license_id, :valid_from)
    end
end
