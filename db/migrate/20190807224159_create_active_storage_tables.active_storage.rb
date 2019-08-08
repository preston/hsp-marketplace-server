# This migration comes from active_storage (originally 20170806125915)
class CreateActiveStorageTables < ActiveRecord::Migration[5.2]
  def change
    create_table :active_storage_blobs, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string   :key,        null: false
      t.string   :filename,   null: false
      t.string   :content_type
      t.text     :metadata
      t.bigint   :byte_size,  null: false
      t.string   :checksum,   null: false
      t.datetime :created_at, null: false

      t.index [ :key ], unique: true
    end

    create_table :active_storage_attachments, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string     :name,     null: false
      t.uuid :record_id, null: false     # replaces t.references :record
      t.string :record_type, null: false # replaces t.references :record
      t.uuid :blob_id,     null: false   # replaces t.references :blob

      t.datetime :created_at, null: false

      t.index [ :record_type, :record_id, :name, :blob_id ], name: "index_active_storage_attachments_uniqueness", unique: true
      t.foreign_key :active_storage_blobs, column: :blob_id
    end

    drop_table :images
    drop_table :logos
    remove_column :products, :logo_file_name, :string
    remove_column :products, :logo_content_type, :string
    remove_column :products, :logo_file_size, :bigint
    remove_column :products, :logo_updated_at, :datetime
    remove_column :screenshots, :image_file_name, :string
    remove_column :screenshots, :image_content_type, :string
    remove_column :screenshots, :image_file_size, :bigint
    remove_column :screenshots, :image_updated_at, :datetime

  end
end
