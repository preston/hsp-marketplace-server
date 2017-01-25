class IdentityProvidersController < ApplicationController
    load_and_authorize_resource

    def index
        @identity_providers = IdentityProvider.paginate(page: params[:page], per_page: params[:per_page])
        sort = %w(name issuer).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @identity_providers = @identity_providers.order(sort => order)
        @identity_providers = @identity_providers.search_by_name(params[:name]) if params[:name]
    end

    def show; end

    def redirect
        redirect_to_identity_provider @identity_provider
    end

    def enable
        @identity_provider.update(enabled_at: Time.now)
        render :show
      end

    def disable
        @identity_provider.update(enabled_at: nil)
        render :show
    end

    def create
        @identity_provider = IdentityProvider.new(identity_provider_params)

        respond_to do |format|
            if @identity_provider.save
                format.json { render :show, status: :created, location: @identity_provider }
            else
                format.json { render json: @identity_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @identity_provider.update(identity_provider_params)
                format.json { render :show, status: :ok, location: @identity_provider }
            else
                format.json { render json: @identity_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @identity_provider.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_provider_params
        params.require(:identity_provider).permit(:name, :issuer, :enabled_at, :client_id, :client_secret, :alternate_client_id, :scopes)
    end
end
