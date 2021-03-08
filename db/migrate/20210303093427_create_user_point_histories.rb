class CreateUserPointHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :user_point_histories do |t|
      t.integer :point_type
      t.float :amount
      t.references :user, null: false, foreign_key: true
      t.references :user_point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
