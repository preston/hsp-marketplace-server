class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.uuid :configuration_id,	null: false
      t.string :name,	null: false
      t.integer :minimum,	null: false, default: 0
      t.integer :maximum,	null: false, default: 0
      t.integer :memory,	null: false, default: 1024

      t.timestamps
    end
    add_index :tasks, :configuration_id
    add_foreign_key :tasks, :configurations
  end
end
