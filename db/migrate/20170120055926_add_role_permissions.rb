class AddRolePermissions < ActiveRecord::Migration[5.0]
    def change
        add_column :roles, :permissions, :json, default: {}, null: false
        remove_column :roles, :code, :string, null: false
    end
end
