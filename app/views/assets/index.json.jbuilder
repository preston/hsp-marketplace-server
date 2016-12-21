json.extract! @assets, :total_pages, :previous_page, :next_page, :total_entries
json.results do
	json.partial! 'assets/asset', collection: @assets, as: :asset
end
