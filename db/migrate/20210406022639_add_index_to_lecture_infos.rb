class AddIndexToLectureInfos < ActiveRecord::Migration[6.1]
  def change
    add_index :lecture_infos, :faculty
    add_index :lecture_infos, :department
    add_index :lecture_infos, :major
    add_index :lecture_infos, :day_of_week
    add_index :lecture_infos, :semester
    add_index :lecture_infos, :period
  end
end
