json.extract! screenshot, :id, :service_id, :caption, :created_at, :updated_at

# Paperclip-managed fields
json.extract! screenshot, :image_file_name, :image_file_size, :image_content_type, :image_updated_at

json.url service_screenshot_url(screenshot.service, screenshot, format: :json)
