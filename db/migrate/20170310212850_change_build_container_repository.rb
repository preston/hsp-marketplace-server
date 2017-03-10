class ChangeBuildContainerRepository < ActiveRecord::Migration[5.0]
  def change
      rename_column :builds, :container_respository_url, :container_repository
  end
end
