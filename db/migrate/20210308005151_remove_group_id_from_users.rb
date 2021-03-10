class RemoveGroupIdFromUsers < ActiveRecord::Migration[6.1]
  def up
    remove_column :users, :group_id
  end

  def down
    add_column :users, :group_id, :integer
  end
end
