class CreateInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :instances, id: :uuid do |t|
      t.uuid :platform_id,	null: false
      t.uuid :build_id,	null: false
      t.json :launch_bindings,	null: false, default: {}
      t.datetime :deployed_at

      t.timestamps
    end
	add_index	:instances,	:platform_id
	add_index	:instances,	:build_id
	add_foreign_key	:instances,	:platforms
	add_foreign_key	:instances,	:builds
  end
end
