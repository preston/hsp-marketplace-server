class RemoveOldAuthentication < ActiveRecord::Migration[5.2]
  def change
    drop_table  :sessions
    drop_table  :clients
  end
end
