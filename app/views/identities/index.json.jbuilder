json.extract! @identities, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'identities/identity', collection: @identities, as: :identity
end
