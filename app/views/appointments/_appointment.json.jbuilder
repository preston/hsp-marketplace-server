json.extract! appointment, :id, :user_id, :role_id, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)