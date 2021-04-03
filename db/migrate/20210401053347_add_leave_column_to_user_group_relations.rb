class AddLeaveColumnToUserGroupRelations < ActiveRecord::Migration[6.1]
  def change
    add_column :user_group_relations, :leave, :boolean, default: false, null: false
  end
end
