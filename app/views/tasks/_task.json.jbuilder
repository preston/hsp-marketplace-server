json.extract! task, :id, :configuration_id, :name, :minimum, :maximum, :memory, :created_at, :updated_at
json.url task_url(task, format: :json)