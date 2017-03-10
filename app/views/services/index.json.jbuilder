json.extract! @services, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'services/service', collection: @services, as: :service
end
