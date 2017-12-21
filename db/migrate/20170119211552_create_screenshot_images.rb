class CreateScreenshotImages < ActiveRecord::Migration[5.0]
    def self.up
        create_table :images, id: :uuid do |t|
            t.uuid :screenshot_id, null: false
            t.string     :style
            t.binary     :file_contents

            t.timestamps
        end
		add_index :images, :screenshot_id
		add_foreign_key :images, :screenshots, on_delete: :cascade

    end

    def self.down
        drop_table :images
    end
end
