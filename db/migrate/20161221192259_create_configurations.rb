class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configurations, id: :uuid do |t|
      t.uuid :build_id,	null: false
      t.string :name,	null: false

      t.timestamps
    end
    add_index :configurations, :build_id
    add_foreign_key :configurations, :builds
  end
end
