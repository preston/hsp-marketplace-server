class IdentityProvider < ActiveRecord::Base

	has_many	:identities, dependent: :destroy

	validates	:issuer,                 presence: true, uniqueness: true
	validates	:name,                   presence: true, uniqueness: true
	validates	:client_id,              presence: true
	validates	:client_secret,              presence: true


	@@CLIENT_CACHE = ThreadSafe::Cache.new

	before_update	:reconfigure #update_handler

	def client_auth_method
		supported = self.configuration[:token_endpoint_auth_methods_supported]
		if supported.present? && !supported.include?('client_secret_basic')
			:post
		else
			:basic
		end
	end

	def reconfigure
		# url = self.issuer + '/.well-known/openid-configuration'
		response = OpenIDConnect::Discovery::Provider::Config.discover! self.issuer
		self.configuration	= response.raw
		self.public_keys	= response.public_keys.collect{|pk| pk.to_s}
		self
	end

	# def update_handler
	# 	self.reconfigure
	# end

	# Isssues with Google at the moment.
	# class << self
	# 	def discover!(host)
	# 		issuer = OpenIDConnect::Discovery::Provider.discover!(host).issuer
	# 		if provider = find_by_issuer(issuer)
	# 			provider
	# 		else
	# 			dynamic.create(
	# 				issuer: issuer,
	# 				name: host
	# 			)
	# 		end
	# 	end
	# end

end
