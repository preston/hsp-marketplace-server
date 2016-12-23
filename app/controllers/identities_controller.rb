class IdentitiesController < ApplicationController


	# load_and_authorize_resource
	load_resource

	def destroy
		@identity.destroy
		if @identity.id == current_identity.id
			unauthenticate!
			redirect_to root_path
		else
			redirect_to dashboard_path
		end
	end


end
