json.extract! product, :id, :name, :description, :external_id, :locale, :user_id, :uri, :support_url, :published_at, :visible_at, :created_at, :updated_at
json.url product_url(product)
json.path product_path(product)

json.product_licenses do
	json.array! product.product_licenses, partial: 'product_licenses/product_license', as: :product_license
end


# Paperclip-managed fields
json.extract! product, :logo_file_name, :logo_file_size, :logo_content_type, :logo_updated_at

json.screenshots do
	json.array! product.screenshots, partial: 'screenshots/screenshot', as: :screenshot
end
