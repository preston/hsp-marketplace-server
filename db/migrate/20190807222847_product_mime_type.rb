class ProductMimeType < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :mime_type, :string, nil: true
  end
end
