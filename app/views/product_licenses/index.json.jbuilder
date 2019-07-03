json.extract! @product_licenses, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! "product_licenses/product_license", collection: @product_licenses, as: :product_license
end
