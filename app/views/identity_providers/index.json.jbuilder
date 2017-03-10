json.extract! @identity_providers, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'identity_providers/identity_provider', collection: @identity_providers, as: :identity_provider
end
