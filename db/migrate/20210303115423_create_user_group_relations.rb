class CreateUserGroupRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :user_group_relations do |t|
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
    add_index :user_group_relations, :user_id
    add_index :user_group_relations, :group_id
    add_index :user_group_relations, [:user_id, :group_id], unique: true
  end
end
