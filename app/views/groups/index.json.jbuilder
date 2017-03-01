json.extract! @groups, :total_pages, :previous_page, :next_page, :current_page
json.total_results @groups.total_entries
json.results do
	json.partial! 'groups/group', collection: @groups, as: :group
end
