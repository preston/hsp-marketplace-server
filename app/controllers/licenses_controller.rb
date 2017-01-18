class LicensesController < ApplicationController
    before_action :set_license, only: [:show, :edit, :update, :destroy]

    # GET /licenses
    # GET /licenses.json
    def index
# debugger
        @licenses = License.paginate(page: params[:page], per_page: params[:per_page])
        sort = %w(name url).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @licenses = @licenses.order(sort => order)
        @licenses = @licenses.search_by_name(params[:filter]) if params[:filter]
    end

    # GET /licenses/1
    # GET /licenses/1.json
    def show; end

    # POST /licenses
    # POST /licenses.json
    def create
        @license = License.new(license_params)

        respond_to do |format|
            if @license.save
                format.json { render :show, status: :created, location: @license }
            else
                format.json { render json: @license.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /licenses/1
    # PATCH/PUT /licenses/1.json
    def update
        respond_to do |format|
            if @license.update(license_params)
                format.json { render :show, status: :ok, location: @license }
            else
                format.json { render json: @license.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /licenses/1
    # DELETE /licenses/1.json
    def destroy
        @license.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_license
        @license = License.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def license_params
        params.require(:license).permit(:name, :url)
    end
end
