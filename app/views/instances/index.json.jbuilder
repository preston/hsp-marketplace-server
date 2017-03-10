json.extract! @instances, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'instances/instance', collection: @instances, as: :instance
end
