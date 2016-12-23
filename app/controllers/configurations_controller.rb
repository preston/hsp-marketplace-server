class ConfigurationsController < ApplicationController
    load_and_authorize_resource

    # GET /configurations
    # GET /configurations.json
    def index
        @configurations = Configuration.all
    end

    # GET /configurations/1
    # GET /configurations/1.json
    def show; end

    # POST /configurations
    # POST /configurations.json
    def create
        @configuration = Configuration.new(configuration_params)

        respond_to do |format|
            if @configuration.save
                format.html { redirect_to @configuration, notice: 'Configuration was successfully created.' }
                format.json { render :show, status: :created, location: @configuration }
            else
                format.html { render :new }
                format.json { render json: @configuration.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /configurations/1
    # PATCH/PUT /configurations/1.json
    def update
        respond_to do |format|
            if @configuration.update(configuration_params)
                format.html { redirect_to @configuration, notice: 'Configuration was successfully updated.' }
                format.json { render :show, status: :ok, location: @configuration }
            else
                format.html { render :edit }
                format.json { render json: @configuration.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /configurations/1
    # DELETE /configurations/1.json
    def destroy
        @configuration.destroy
        respond_to do |format|
            format.html { redirect_to configurations_url, notice: 'Configuration was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_configuration
        @configuration = Configuration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def configuration_params
        params.require(:configuration).permit(:build_id, :name)
    end
end
