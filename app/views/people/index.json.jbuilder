json.extract! @users, :total_pages, :previous_page, :next_page
json.total_results @users.total_entries
json.results do
	json.partial! 'users/user', collection: @users, as: :user
end
