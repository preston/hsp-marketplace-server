class RolesController < ApplicationController
    load_and_authorize_resource

    def index
        @roles = Role.paginate(page: params[:page], per_page: params[:per_page])
        @roles = @roles.includes(:appointments)
        sort = %w(name default).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @roles = @roles.order(sort => order)
        if params[:default]
            @roles = @roles.where(default: (params[:default] == 'true'))
        end
        @roles = @roles.search_by_name(params[:filter]) if params[:filter]
    end

    def show; end

    def create
        @role = Role.new(role_params)
        # FIXME: Why doesn't role_params "permit" work for JSON parameters???
        # byebug
        @role.permissions = Role.permissions_template
        # puts permissions_from_params
        @role.merge_permissions_of permissions_from_params
        respond_to do |format|
            if @role.save
                format.json { render :show, status: :created, location: @role }
            else
                format.json { render json: @role.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def update
        # puts params[:role][:permissions].to_json
        # FIXME Why doesn't role_params "permit" work for JSON parameters???
        # byebug
        @role.merge_permissions_of permissions_from_params
        respond_to do |format|
            if @role.update(role_params)
                format.json { render :show, status: :ok, location: @role }
            else
                format.json { render json: @role.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @role.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    def permissions_from_params
        perms = {}
        tmp = params[:role][:permissions]
        if tmp && tmp.respond_to?(:to_unsafe_hash)
            perms = tmp.to_unsafe_hash
            if perms.is_a?(Hash)
                perms.each do |resource, verbs|
                    next unless verbs.is_a?(Hash)
                    # puts verb #perms[resource][verb]
                    verbs.each do |verb, value|
                        perms[resource][verb] = (value.to_s == 'true')
                    end
                end
            end
        end
        perms
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
        params.require(:role).permit(:name, :description, :default)
    end
end
