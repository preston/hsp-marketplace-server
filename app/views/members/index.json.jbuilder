json.array!(@members) do |member|
  json.extract! member, :id, :group_id, :user_id
  json.url member_url(member, format: :json)
end
