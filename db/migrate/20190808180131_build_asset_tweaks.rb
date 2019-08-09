class BuildAssetTweaks < ActiveRecord::Migration[5.2]
  def change
    change_column :builds, :container_tag,  :string,  null: true
    change_column :builds, :container_repository,  :string,  null: true
    remove_column :builds,  :product_version, :string,  null: false
    add_index :sub_products, [:parent_id, :child_id]
  end
end
