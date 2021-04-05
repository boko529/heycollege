class CreateLectureInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :lecture_infos do |t|
      t.integer :faculty
      t.integer :department
      t.integer :major
      t.integer :day_of_week
      t.integer :semester
      t.integer :period
      t.references :lecture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
