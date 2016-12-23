class CreateInterfaces < ActiveRecord::Migration[5.0]
  def change
    create_table :interfaces, id: :uuid do |t|
      t.string :name,	null: false
      t.string :uri,	null: false
      t.string :version,	null: false
      t.integer :ordinal

      t.timestamps
    end
  end
end
