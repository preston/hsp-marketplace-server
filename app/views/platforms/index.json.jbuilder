json.extract! @platforms, :total_pages, :previous_page, :next_page, :current_page
json.total_results @platforms.total_entries
json.results do
	json.partial! 'platforms/platform', collection: @platforms, as: :platform
end

# json.array! @platforms, partial: 'platforms/platform', as: :platform
