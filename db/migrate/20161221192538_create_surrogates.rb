class CreateSurrogates < ActiveRecord::Migration[5.0]
  def change
    create_table :surrogates, id: :uuid do |t|
      t.uuid :interface_id,	null: false
      t.uuid :substitute_id,	null: false

      t.timestamps
    end
    add_index :surrogates, :interface_id
    add_index :surrogates, :substitute_id
    add_foreign_key :surrogates, :interfaces,	column: :interface_id
    add_foreign_key :surrogates, :interfaces,	column: :substitute_id
  end
end
