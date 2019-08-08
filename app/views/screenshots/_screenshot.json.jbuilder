json.extract! screenshot, :id, :product_id, :caption, :created_at, :updated_at

# ActiveStorage fields
# json.image_file_name screenshot.image_blob.filename
# json.image_content_type screenshot.image_blob.content_type
json.image_updated_at screenshot.image_attachment.created_at

json.url product_screenshot_url(screenshot.product, screenshot)
json.path product_screenshot_path(screenshot.product, screenshot)
