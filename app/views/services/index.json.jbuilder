json.extract! @services, :total_pages, :previous_page, :next_page, :current_page
json.total_results @services.total_entries
json.results do
	json.partial! 'services/service', collection: @services, as: :service
end
