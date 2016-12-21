json.extract! usage_role, :id, :activity_id, :asset_id, :semantic_uri
json.extract! usage_role, :created_at,	:updated_at
json.url activity_usage_role_url(usage_role.activity, usage_role)
json.path activity_usage_role_path(usage_role.activity, usage_role)
