class CreateVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :vouchers, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.uuid :product_license_id
      t.uuid :entitlement_id
      t.string :code
      t.datetime :issued_at
      t.datetime :expires_at
      t.datetime :redeemed_at
      t.uuid :redeemed_by

      t.timestamps
    end
  end
end
