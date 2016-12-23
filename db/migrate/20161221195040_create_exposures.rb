class CreateExposures < ActiveRecord::Migration[5.0]
    def change
        create_table :exposures, id: :uuid do |t|
            t.uuid :build_id, null: false
            t.uuid :interface_id, null: false

            t.timestamps
        end
        add_index :exposures, :build_id
        add_index :exposures, :interface_id
        add_foreign_key :exposures, :builds
        add_foreign_key :exposures, :interfaces
    end
end
