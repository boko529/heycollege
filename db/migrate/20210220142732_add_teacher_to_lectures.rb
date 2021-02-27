class AddTeacherToLectures < ActiveRecord::Migration[6.1]
  def change
    add_reference :lectures, :teacher, null: false, foreign_key: true
  end
end
