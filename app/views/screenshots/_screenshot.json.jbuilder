json.extract! screenshot, :id, :product_id, :caption, :created_at, :updated_at

# Paperclip-managed fields
json.extract! screenshot, :image_file_name, :image_file_size, :image_content_type, :image_updated_at

json.url product_screenshot_url(screenshot.product, screenshot)
json.path product_screenshot_path(screenshot.product, screenshot)
