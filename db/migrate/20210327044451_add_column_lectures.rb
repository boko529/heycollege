class AddColumnLectures < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :lecture_term, :integer
    add_column :lectures, :day_of_week, :integer
    add_column :lectures, :period, :integer
    add_index :lectures, :lecture_term
    add_index :lectures, :day_of_week
    add_index :lectures, :period
  end
end
