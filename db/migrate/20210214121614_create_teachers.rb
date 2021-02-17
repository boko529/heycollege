class CreateTeachers < ActiveRecord::Migration[6.1]
  def change
    create_table :teachers do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps

    end
    add_index :teachers, [:user_id, :created_at]
  end
end
