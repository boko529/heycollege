class RemoveColumnsFromLectures < ActiveRecord::Migration[6.1]
  def change
    remove_column :lectures, :language_used, :integer
    remove_column :lectures, :lecture_type, :integer
    remove_column :lectures, :lecture_term, :integer
    remove_column :lectures, :lecture_size, :integer
    remove_column :lectures, :group_work, :integer
  end
end
