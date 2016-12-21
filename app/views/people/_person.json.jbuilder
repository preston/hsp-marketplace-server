json.extract! user, :id, :external_id, :name, :first_name, :middle_name, :last_name
json.url user_url(user)
json.path user_path(user)
# json.memberships do
# 	json.array! user.memberships do |m|
# 		json.extract! m, :id
# 		json.url group_member_url(m.group, m)
# 		json.path group_member_path(m.group, m)
# 		json.group do
# 			json.extract! m.group, :id, :name
# 			json.url group_url(m.group)
# 			json.path group_path(m.group)
# 		end
# 	end
# end
