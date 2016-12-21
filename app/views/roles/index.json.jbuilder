json.array!(@roles) do |role|
  json.extract! role, :id, :name, :code, :description
  json.url role_url(role, format: :json)
end
