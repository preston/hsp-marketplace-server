class CreateClaims < ActiveRecord::Migration[5.2]
  def change
    create_table :claims, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.uuid :claimant_id
      t.string :claimant_type
      t.uuid :entitlement_id
      t.integer :authorization_count
      t.datetime :authorized_at

      t.timestamps
    end
  end
end
