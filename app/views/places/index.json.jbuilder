json.extract! @places, :total_pages, :previous_page, :next_page, :total_entries
json.results do
	json.partial! 'places/place', collection: @places, as: :place
end
