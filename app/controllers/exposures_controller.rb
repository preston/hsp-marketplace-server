class ExposuresController < ApplicationController
    
    load_and_authorize_resource	:service
    load_and_authorize_resource	:build
    load_and_authorize_resource	:exposure


  # GET /exposures
  # GET /exposures.json
  def index
    @exposures = Exposure.all
  end

  # GET /exposures/1
  # GET /exposures/1.json
  def show
  end

  # POST /exposures
  # POST /exposures.json
  def create
    @exposure = Exposure.new(exposure_params)

    respond_to do |format|
      if @exposure.save
        format.html { redirect_to @exposure, notice: 'Exposure was successfully created.' }
        format.json { render :show, status: :created, location: @exposure }
      else
        format.html { render :new }
        format.json { render json: @exposure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exposures/1
  # PATCH/PUT /exposures/1.json
  def update
    respond_to do |format|
      if @exposure.update(exposure_params)
        format.html { redirect_to @exposure, notice: 'Exposure was successfully updated.' }
        format.json { render :show, status: :ok, location: @exposure }
      else
        format.html { render :edit }
        format.json { render json: @exposure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exposures/1
  # DELETE /exposures/1.json
  def destroy
    @exposure.destroy
    respond_to do |format|
      format.html { redirect_to exposures_url, notice: 'Exposure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exposure
      @exposure = Exposure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exposure_params
      params.require(:exposure).permit(:build_id, :interface_id)
    end
end
