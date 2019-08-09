json.extract! product, :id, :name, :description, :external_id, :locale, :mime_type, :user_id, :uri, :support_url, :published_at, :visible_at, :created_at, :updated_at

json.url product_url(product)
json.path product_path(product)

json.product_licenses do
	json.array! product.product_licenses, partial: 'product_licenses/product_license', as: :product_license
end

# ActiveStorage fields
# json.logo_file_name product.logo_blob.filename
# json.logo_content_type product.logo_blob.content_type
# json.logo_updated_at product.logo_attachment.created_at

json.screenshots do
	json.array! product.screenshots, partial: 'screenshots/screenshot', as: :screenshot
end
