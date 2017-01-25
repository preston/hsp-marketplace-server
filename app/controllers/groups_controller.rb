class GroupsController < ApplicationController
    load_and_authorize_resource

    def index
        @groups = Group.paginate(page: params[:page], per_page: params[:per_page])
        if params[:role]
            @groups = @groups.joins(appointments: :role).where('roles.id = ?', params[:role])
        end
        sort = %w(name description).include?(params[:sort]) ? params[:sort] : :name
        order = 'desc' == params[:order] ? :desc : :asc
        @groups = @groups.order(sort => order)
        @groups = @groups.search_by_name(params[:name]) if params[:name]
    end

    def show; end

    def create
        @group = Group.new(group_params)

        respond_to do |format|
            if @group.save
                format.html { redirect_to @group, notice: 'Group was successfully created.' }
                format.json { render :show, status: :created, location: @group }
            else
                format.html { render :new }
                format.json { render json: @group.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @group.update(group_params)
                format.html { redirect_to @group, notice: 'Group was successfully updated.' }
                format.json { render :show, status: :ok, location: @group }
            else
                format.html { render :edit }
                format.json { render json: @group.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /groups/1
    # DELETE /groups/1.json
    def destroy
        @group.destroy
        respond_to do |format|
            format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_group
        @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
        params.require(:group).permit(:name, :description)
    end
end
