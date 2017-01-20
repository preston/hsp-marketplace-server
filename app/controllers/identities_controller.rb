class IdentitiesController < ApplicationController
    load_and_authorize_resource	:user
    load_and_authorize_resource

    def index
        @identities = @user.identities
    end

    def show; end

    def create
        @identity = Identity.new(identity_params)

        respond_to do |format|
            if @identity.save
                format.json { render :show, status: :created, location: user_identity_url(@user, @identity) }
            else
                format.json { render json: @identity.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @identity.update(identity_params)
                format.json { render :show, status: :ok, location: user_identity_url(@user, @identity) }
            else
                format.json { render json: @identity.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @identity.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def identity_params
        params.require(:identity).permit(
            :user_id,
            :identity_provider_id,
            :sub,
            :iat,
            :hd,
            :locale,
            :email,
            :jwt,
            :notify_via_email,
            :notify_via_sms
        )
    end
end
