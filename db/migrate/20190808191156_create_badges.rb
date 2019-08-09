class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :badges, :name, unique: true

    create_table :badges_products, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.uuid  :badge_id,  null: false
      t.uuid  :product_id,  null: false
      t.timestamps
    end
    add_index :badges_products, [:badge_id, :product_id], unique: true
  end
end
