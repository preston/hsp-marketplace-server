json.extract! @groups, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'groups/group', collection: @groups, as: :group
end
