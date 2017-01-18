json.extract! identity_provider, :id, :name, :issuer, :client_id, :client_secret, :alternate_client_id, :scopes, :configuration, :public_keys, :created_at, :updated_at
json.redirect_url redirect_identity_provider_url(identity_provider, format: :json)
json.path identity_provider_path(identity_provider, format: :json)
json.url identity_provider_url(identity_provider, format: :json)
