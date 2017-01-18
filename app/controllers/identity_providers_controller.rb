class IdentityProvidersController < ApplicationController

    load_and_authorize_resource

    # GET /identity_providers
    # GET /identity_providers.json
    def index
        @identity_providers = IdentityProvider.all
    end

    # GET /identity_providers/1
    # GET /identity_providers/1.json
    def show; end

	# GET /identity_providers/1/redirect
	def redirect
		redirect_to_identity_provider @identity_provider
	end

    # POST /identity_providers
    # POST /identity_providers.json
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

    # PATCH/PUT /identity_providers/1
    # PATCH/PUT /identity_providers/1.json
    def update
        respond_to do |format|
            if @identity_provider.update(identity_provider_params)
                format.json { render :show, status: :ok, location: @identity_provider }
            else
                format.json { render json: @identity_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /identity_providers/1
    # DELETE /identity_providers/1.json
    def destroy
        @identity_provider.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_provider_params
        params.require(:identity_provider).permit(:name, :issuer, :client_id, :client_secret, :alternate_client_id, :scopes)
    end
end
