json.extract! objective, :id, :activity_id, :formalized, :language, :semantic_uri, :specification, :comment
json.extract! objective, :created_at,	:updated_at
json.url activity_objective_url(objective.activity, objective)
json.path activity_objective_path(objective.activity, objective)
