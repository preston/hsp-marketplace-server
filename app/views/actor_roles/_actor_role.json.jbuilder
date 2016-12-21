json.extract! actor_role, :id, :activity_id, :user_id, :semantic_uri
json.extract! actor_role, :created_at,	:updated_at
json.url activity_actor_role_url(actor_role.activity, actor_role)
json.path activity_actor_role_path(actor_role.activity, actor_role)
