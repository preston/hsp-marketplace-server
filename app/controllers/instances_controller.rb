class InstancesController < ApplicationController

    load_and_authorize_resource
    load_and_authorize_resource :platform
    load_and_authorize_resource :user

    def index
        @instances = Instance.paginate(page: params[:page], per_page: params[:per_page])
    end

    def show; end

    def create
        @instance = Instance.new(instance_params)

        respond_to do |format|
            if @instance.save
                format.json { render :show, status: :created, location: @instance }
            else
                format.json { render json: @instance.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @instance.update(instance_params)
                format.json { render :show, status: :ok, location: @instance }
            else
                format.json { render json: @instance.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @instance.destroy
        respond_to do |format|
            format.json { render :show  }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def instance_params
        params.require(:instance).permit(:platform_id, :build_id, :launch_bindings, :deployed_at)
    end
end
