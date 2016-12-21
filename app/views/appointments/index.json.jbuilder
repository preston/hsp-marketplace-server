json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :entity_id, :entity_type, :role_id
  json.url appointment_url(appointment, format: :json)
end
