class CreateGroupPointHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :group_point_histories do |t|
      t.integer :point_type
      t.float :amount
      t.references :group, null: false, foreign_key: true
      t.references :group_point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
