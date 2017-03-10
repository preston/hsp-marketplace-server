json.extract! @roles, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'roles/role', collection: @roles, as: :role
end
