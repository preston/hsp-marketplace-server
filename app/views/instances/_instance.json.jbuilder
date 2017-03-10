json.extract! instance, :id, :platform_id, :build_id, :launch_bindings, :deployed_at, :created_at, :updated_at
json.url user_platform_instance_url(instance.platform.user, instance.platform, instance, format: :json)
json.path user_platform_instance_path(instance.platform.user, instance.platform, instance, format: :json)
