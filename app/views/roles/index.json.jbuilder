json.array!(@roles) do |role|
  json.extract! role, :id, :name, :code, :description, :default
  json.path role_path(role)
  json.url role_url(role)
end
