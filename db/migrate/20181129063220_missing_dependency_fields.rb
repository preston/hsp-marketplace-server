class MissingDependencyFields < ActiveRecord::Migration[5.2]
  def change
    add_column :dependencies, :required, :boolean, null: false, default: true
    add_column :dependencies, :mappings, :json, null: false, default: {}
  end
end
