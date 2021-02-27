class AddTeacherNameToLectures < ActiveRecord::Migration[6.1]
  def change
    add_column :lectures, :teacher_name, :string
  end
end
