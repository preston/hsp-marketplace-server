class UsersController < ApplicationController
    load_and_authorize_resource

    def index
        @users = User.paginate(page: params[:page], per_page: params[:per_page])
        if params[:role]
            @users = @users.joins(appointments: :role).where('roles.code = ?', params[:role])
        end
        sort = %w(name external_id).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @users = @users.order(sort => order)
        if params[:external_id] # External IDs are not gauranteed to be unique, so we may have multiple results.
            @users = @users.where('external_id = ?', params[:external_id])
        end
        @users = @users.search_by_name(params[:name]) if params[:name]
      end

    def show; end

    def create
        @user = User.new(user_params)

        respond_to do |format|
            if @user.save
                format.json { render :show, status: :created, location: @user }
            else
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @user.update(user_params)
                format.json { render :show, status: :ok, location: @user }
            else
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @user.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
        params.require(:user).permit(:name, :external_id, :salutation, :first_name, :middle_name, :last_name)
    end

end
