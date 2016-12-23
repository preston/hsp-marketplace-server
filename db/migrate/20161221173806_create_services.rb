class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services, id: :uuid do |t|
      t.string :name,	null: false
      t.text :description
      t.uuid :user_id
      t.string :uri
      t.string :support_url
      t.uuid :license_id
      t.datetime :approved_at
      t.datetime :visible_at

      t.timestamps
    end
    add_index :services, :name, unique: true
    add_foreign_key :services, :users
  end
end
