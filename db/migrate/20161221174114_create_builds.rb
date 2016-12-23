class CreateBuilds < ActiveRecord::Migration[5.0]
    def change
        create_table :builds, id: :uuid do |t|
            t.uuid :service_id,	null: false
            t.string :service_version,	null: false
            t.string :version,	null: false
            t.string :container_respository_url,	null: false
            t.string :container_tag,	null: false
            t.datetime :validated_at
            t.datetime :published_at
            t.json :permissions,	null: false, default: {}
            t.text :release_notes

            t.timestamps
        end
        add_index :builds, :id
		add_foreign_key	:builds,	:services
    end
end
