json.extract! @builds, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'builds/build', collection: @builds, as: :build
end
