class RenameServiceApprovedAt < ActiveRecord::Migration[5.0]
    def change
        rename_column :services, :approved_at, :published_at
    end
end
