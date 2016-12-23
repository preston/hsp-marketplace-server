class CreatePlatforms < ActiveRecord::Migration[5.0]
  def change
    create_table :platforms, id: :uuid do |t|
      t.string :name,	null: false
      t.uuid :user_id,	null: false
      t.text :public_key

      t.timestamps
    end
    add_index :platforms, :user_id
    add_foreign_key :platforms, :users
  end
end
