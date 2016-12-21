class ClientsController < ApplicationController

	load_and_authorize_resource :client

	def index
		@clients = Client.all
	end

	def launch
		# redirect_to @client.launch_url
	end

end
