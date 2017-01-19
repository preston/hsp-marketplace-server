json.extract! service, :id, :name, :description, :user_id, :uri, :support_url, :license_id, :approved_at, :visible_at, :created_at, :updated_at
json.url service_url(service, format: :json)

# Paperclip-managed fields
json.extract! service, :logo_file_name, :logo_file_size, :logo_content_type, :logo_updated_at

json.screenshots do
	json.array! service.screenshots, partial: 'screenshots/screenshot', as: :screenshot
end
