class AddConfirmationToUserGroupRelations < ActiveRecord::Migration[6.1]
  def change
    add_column :user_group_relations, :confirmation, :boolean, default: false, null: false
  end
end
