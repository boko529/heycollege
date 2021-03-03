class RemoveTeacherNameFromLectures < ActiveRecord::Migration[6.1]
  def change
    remove_column :lectures, :teacher_name, :string
  end
end
