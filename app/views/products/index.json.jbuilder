json.extract! @products, :total_pages, :total_entries, :previous_page, :next_page, :current_page
json.results do
	json.partial! 'products/product', collection: @products, as: :product
end
