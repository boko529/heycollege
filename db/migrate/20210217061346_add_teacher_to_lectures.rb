class AddTeacherToLectures < ActiveRecord::Migration[6.1]
  def change
    add_reference :lectures, :teacher, foreign_key: true
  end
end
