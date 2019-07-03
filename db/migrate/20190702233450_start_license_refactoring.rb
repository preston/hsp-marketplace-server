# frozen_string_literal: true

class StartLicenseRefactoring < ActiveRecord::Migration[5.2]
  def change
    rename_table :services, :products
    remove_column :products, :license_id
    add_column :products,  :external_id, :string, null: true
    add_column :products,  :locale, :string,  null: true
    rename_column :logos,  :service_id,  :product_id
    rename_column :builds, :service_id,  :product_id
    rename_column :builds, :service_version,  :product_version
    rename_column :screenshots, :service_id, :product_id

    add_column  :licenses,  :description, :string
    add_column  :licenses,  :expiry, :integer
    add_column  :licenses,  :expires_at,  :datetime,  null: true
    add_column  :licenses,  :days_valid,  :integer, default: 0
    add_column  :licenses,  :uses, :integer, default: 0
    add_column  :licenses,  :external_id, :string,  null: true
  end
end
