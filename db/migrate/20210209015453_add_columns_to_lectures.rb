class AddColumnsToLectures < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :language_used, :integer
    add_column :lectures, :lecture_type, :integer
    add_column :lectures, :lecture_term, :integer
    add_column :lectures, :lecture_size, :integer
  end
end
