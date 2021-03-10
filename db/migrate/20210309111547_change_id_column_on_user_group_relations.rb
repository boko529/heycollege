class ChangeIdColumnOnUserGroupRelations < ActiveRecord::Migration[6.1]
  def change
    # user_id, group_idにNotNull制約、default値0で追加.
    change_column_null :user_group_relations, :user_id, false, 0
    change_column :user_group_relations, :user_id, :integer, default: 0
    change_column_null :user_group_relations, :group_id, false, 0
    change_column :user_group_relations, :group_id, :integer, default: 0
  end
end
