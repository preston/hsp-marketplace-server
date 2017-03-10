json.extract! @licenses, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'licenses/license', collection: @licenses, as: :license
end
