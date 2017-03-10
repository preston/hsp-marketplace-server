json.extract! @users, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'users/user', collection: @users, as: :user
end
