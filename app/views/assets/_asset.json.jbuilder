json.extract! asset, :id, :uri
json.extract! asset, :created_at,	:updated_at
json.url asset_url(asset)
json.path asset_path(asset)
