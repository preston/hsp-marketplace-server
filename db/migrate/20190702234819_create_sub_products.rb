class CreateSubProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_products, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.uuid :parent_id
      t.uuid :child_id

      t.timestamps
    end
  end
end
