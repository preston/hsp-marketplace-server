json.extract! service, :id, :name, :description, :user_id, :uri, :support_url, :license_id, :approved_at, :visible_at, :created_at, :updated_at
json.url service_url(service, format: :json)