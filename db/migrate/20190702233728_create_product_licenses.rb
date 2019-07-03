class CreateProductLicenses < ActiveRecord::Migration[5.2]
  def change
    create_table :product_licenses, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.uuid :product_id
      t.uuid :license_id
      t.uuid :external_id

      t.timestamps
    end
  end
end
