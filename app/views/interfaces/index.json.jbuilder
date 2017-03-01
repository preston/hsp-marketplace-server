json.extract! @interfaces, :total_pages, :previous_page, :next_page, :current_page
json.total_results @interfaces.total_entries
json.results do
	json.partial! 'interfaces/interface', collection: @interfaces, as: :interface
end
