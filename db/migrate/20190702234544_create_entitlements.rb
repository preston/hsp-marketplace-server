class CreateEntitlements < ActiveRecord::Migration[5.2]
  def change
    create_table :entitlements, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.uuid :user_id
      t.uuid :product_license_id
      t.datetime :valid_from

      t.timestamps
    end
  end
end
