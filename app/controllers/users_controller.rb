class UsersController < ApplicationController

	load_and_authorize_resource

	def index
        @users = User.paginate(page: params[:page], per_page: params[:per_page])
		if params[:role]
			@users = @users.joins(appointments: :role).where('roles.code = ?', params[:role])
		end
        # sort = %w(name external_id).include?(params[:sort]) ? params[:sort] : :name
        # order = 'desc' == params[:order] ? :desc : :asc
        # @users = @users.order(sort => order)
        # if params[:external_id] # External IDs are not gauranteed to be unique, so we may have multiple results.
        #     @users = @users.where('external_id = ?', params[:external_id])
        # end
        @users = @users.search_by_name(params[:name]) if params[:name]
    end

end
