class AddIndexToBookmark < ActiveRecord::Migration[6.1]
  def change
    add_index :bookmarks, [:user_id, :lecture_id], unique: true
  end
end
