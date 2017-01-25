json.extract! @licenses, :total_pages, :previous_page, :next_page
json.total_results @licenses.total_entries
json.results do
	json.partial! 'licenses/license', collection: @licenses, as: :license
end
