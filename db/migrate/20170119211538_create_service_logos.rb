class CreateServiceLogos < ActiveRecord::Migration[5.0]
    def self.up
        create_table :logos, id: :uuid do |t|
            t.uuid :service_id, null: false
            t.string     :style
            t.binary     :file_contents

            t.timestamps
        end
        add_index :logos, :service_id
        add_foreign_key :logos, :services, on_delete: :cascade
    end

    def self.down
        drop_table :logos
    end
end
