class CreateGroupPoints < ActiveRecord::Migration[6.1]
  def change
    create_table :group_points do |t|
      t.float :current_point
      t.float :total_point
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
