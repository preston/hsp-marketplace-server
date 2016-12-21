json.extract! @activities, :total_pages, :previous_page, :next_page, :total_entries
json.results do
	json.partial! 'activities/activity', collection: @activities, as: :activity, recurse: false
end
