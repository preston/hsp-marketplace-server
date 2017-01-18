json.extract! license, :id, :name, :url, :created_at, :updated_at
# Conflicts with the field of the same name:
# json.url license_url(license, format: :json)
