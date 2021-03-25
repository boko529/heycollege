class AutoCreate < ApplicationRecord
  # ログのように使います
  validates :name, presence: true

  def self.import_APU(file)
    # CSV_HEADER = {
    #   "lecture_j" => 'lecture_name',
    #   "teacher_j" => 'teacher_name'
    # }
    CSV.foreach(file.path, headers: true).with_index(2) do |row, row_number|
      lecture_name = row["lecture_j"]
      teacher_name = row["teacher_j"]
      if teacher = Teacher.find_by(name: teacher_name)
        teacher.lectures.create!(name: lecture_name, user_id: 1) # 失敗した際にエラーが出るようにする必要あり、最後にセーブ持っていってトランザクションまとめるのもあり。
      else
        teacher = Teacher.new(name: teacher_name, user_id: 1)
        teacher.save! # if文を用いたほうが良い？
        teacher.lectures.create!(name: lecture_name)
      end
    end
  end
end
