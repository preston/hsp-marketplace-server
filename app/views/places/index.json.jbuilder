json.extract! @places, :total_pages, :previous_page, :next_page, :total_entries, :current_page
json.results do
	json.partial! 'places/place', collection: @places, as: :place
end
