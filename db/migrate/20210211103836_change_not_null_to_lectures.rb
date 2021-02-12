class ChangeNotNullToLectures < ActiveRecord::Migration[6.1]
  def change
    change_column_null :lectures, :user_id, false
  end
end
