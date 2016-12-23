class CreateParameters < ActiveRecord::Migration[5.0]
    def change
        create_table :parameters, id: :uuid do |t|
            t.uuid :exposure_id, null: false
            t.string :name,	null: false
            t.boolean :required

            t.timestamps
        end
        add_index :parameters, :exposure_id
        add_foreign_key :parameters, :exposures
    end
end
