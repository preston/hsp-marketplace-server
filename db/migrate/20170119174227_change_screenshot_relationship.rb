class ChangeScreenshotRelationship < ActiveRecord::Migration[5.0]
    def change
        remove_column	:screenshots, :build_id
        add_column	:screenshots, :service_id, :uuid, null: false
        add_index :screenshots, :service_id
        add_foreign_key :screenshots, :services
    end
end
