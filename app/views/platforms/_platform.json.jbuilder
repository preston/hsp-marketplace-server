json.extract! platform, :id, :id, :name, :user_id, :public_key, :created_at, :updated_at
json.url user_platform_url(platform.user, platform, format: :json)
json.path user_platform_path(platform.user, platform, format: :json)
