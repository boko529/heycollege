class AddColumnToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :group_id, :integer
    add_index :notifications, :group_id
  end
end
