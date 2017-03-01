json.extract! @identity_providers, :total_pages, :previous_page, :next_page
json.total_results @identity_providers.total_entries
json.results do
	json.partial! 'identity_providers/identity_provider', collection: @identity_providers, as: :identity_provider
end
