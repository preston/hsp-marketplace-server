json.extract! @roles, :total_pages, :previous_page, :next_page, :current_page
json.total_results @roles.total_entries
json.results do
	json.partial! 'roles/role', collection: @roles, as: :role
end
