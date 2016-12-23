class CreateLicenses < ActiveRecord::Migration[5.0]
  def change
    create_table :licenses, id: :uuid do |t|
      t.string :name,	null: false
      t.string :url,	null: false

      t.timestamps
    end
    add_index :licenses, :name, unique: true
  end
end
