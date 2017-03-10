json.extract! @interfaces, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'interfaces/interface', collection: @interfaces, as: :interface
end
