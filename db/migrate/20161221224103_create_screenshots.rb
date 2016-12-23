class CreateScreenshots < ActiveRecord::Migration[5.0]
    def change
        create_table :screenshots, id: :uuid do |t|
            t.uuid	:build_id, null: false
            t.string :caption, null: false
            t.string :mime_type, null: false
            t.binary :data, null: false

            t.timestamps
        end
        add_index :screenshots, :build_id
        add_foreign_key :screenshots, :builds
    end
end
