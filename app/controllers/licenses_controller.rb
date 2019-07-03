class LicensesController < ApplicationController
    load_and_authorize_resource	:license

    def index
        @licenses = License.paginate(page: params[:page], per_page: params[:per_page])
        sort = %w(name url external_id expires_at).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @licenses = @licenses.order(sort => order)
        @licenses = @licenses.search_by_name(params[:filter]) if params[:filter]
    end

    def expiries
        @modes = []
        License.expiries.each do |k, _v|
            @modes << { id: k, label: k.humanize }
        end
    end

    def show
    end

    def create
        @license = License.new(license_params)
        respond_to do |format|
            if @license.save
                format.json { render :show, status: :created, location: @license }
            else
                format.json { render json: @license.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @license.update(license_params)
                format.json { render :show, status: :ok, location: @license }
            else
                format.json { render json: @license.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @license.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def license_params
        params.require(:license).permit(:name, :description, :url, :uses, :expiry, :days_valid, :expires_at, :external_id)
    end
end
