class AddUserRefToLecture < ActiveRecord::Migration[6.1]
  def change
    add_reference :lectures, :user, foreign_key: true
    add_index :lectures, [:user_id, :updated_at]
  end
end
