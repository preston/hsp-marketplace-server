class SurrogatesController < ApplicationController
    load_and_authorize_resource
	
    # GET /surrogates
    # GET /surrogates.json
    def index
        @surrogates = Surrogate.all
    end

    # GET /surrogates/1
    # GET /surrogates/1.json
    def show; end

    # POST /surrogates
    # POST /surrogates.json
    def create
        @surrogate = Surrogate.new(surrogate_params)

        respond_to do |format|
            if @surrogate.save
                format.html { redirect_to @surrogate, notice: 'Surrogate was successfully created.' }
                format.json { render :show, status: :created, location: @surrogate }
            else
                format.html { render :new }
                format.json { render json: @surrogate.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /surrogates/1
    # PATCH/PUT /surrogates/1.json
    def update
        respond_to do |format|
            if @surrogate.update(surrogate_params)
                format.html { redirect_to @surrogate, notice: 'Surrogate was successfully updated.' }
                format.json { render :show, status: :ok, location: @surrogate }
            else
                format.html { render :edit }
                format.json { render json: @surrogate.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /surrogates/1
    # DELETE /surrogates/1.json
    def destroy
        @surrogate.destroy
        respond_to do |format|
            format.html { redirect_to surrogates_url, notice: 'Surrogate was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_surrogate
        @surrogate = Surrogate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def surrogate_params
        params.require(:surrogate).permit(:interface_id, :substitute_id)
    end
end
