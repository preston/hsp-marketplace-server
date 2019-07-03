class CreateAttempts < ActiveRecord::Migration[5.2]
  def change
    create_table :attempts, id: :uuid, default: -> { 'uuid_generate_v4()' } do |t|
      t.uuid :claim_id
      t.uuid :claimant_id
      t.string :claimant_type
      t.uuid :product_id

      t.timestamps
    end
  end
end
