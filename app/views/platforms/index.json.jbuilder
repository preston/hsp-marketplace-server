json.extract! @platforms, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'platforms/platform', collection: @platforms, as: :platform
end

# json.array! @platforms, partial: 'platforms/platform', as: :platform
