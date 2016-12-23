class CreateDependencies < ActiveRecord::Migration[5.0]
  def change
    create_table :dependencies, id: :uuid  do |t|
      t.uuid :build_id, null: false
      t.uuid :interface_id, null: false

      t.timestamps
    end
    add_index :dependencies, :build_id
    add_index :dependencies, :interface_id
	add_foreign_key :dependencies, :builds
	add_foreign_key :dependencies, :interfaces
  end
end
