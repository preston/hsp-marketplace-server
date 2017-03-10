# This template is a little special since it deals with sensitive security information.

# These fields are safe to disclose:
json.extract! identity_provider, :id, :name, :issuer, :created_at, :updated_at

# OAuth-related fields should be kept secret. No one needs these except administrators setting up the system.
if can? :update, identity_provider
	json.extract! identity_provider, :client_id, :client_secret, :alternate_client_id, :scopes, :enabled_at, :configuration, :public_keys
end
json.redirect_url redirect_identity_provider_url(identity_provider, format: :json)
json.path identity_provider_path(identity_provider, format: :json)
json.url identity_provider_url(identity_provider, format: :json)
