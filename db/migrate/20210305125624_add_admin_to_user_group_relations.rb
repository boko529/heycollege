class AddAdminToUserGroupRelations < ActiveRecord::Migration[6.1]
  def change
    add_column :user_group_relations, :admin, :boolean, default: false
  end
end
