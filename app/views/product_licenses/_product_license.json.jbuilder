json.extract! product_license, :id, :product_id, :license_id, :external_id, :created_at, :updated_at
json.path product_license_path(product_license.product, product_license, format: :json)
json.url product_license_url(product_license.product, product_license, format: :json)
