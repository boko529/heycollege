class AutoCreate < ApplicationRecord
  # ログのように使います
  validates :name, presence: true

  def self.import_APU(file)
    # CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true).with_index(2) do |row, row_number|
    # 文字コードの関係でAPUのCSVは文字コードをANSIに一度変換しないといけない
    CSV.foreach(file.path, encoding: 'cp932:UTF-8', headers: true).with_index(2) do |row, row_number|
      begin
        @teacher_name = row["先生"]
        @lecture_name = row["講義"].sub(/^\w+\)/, "") # 講義名の冒頭の"Online)"や"Hyblid)"などの")"手前を削除(正規表現で指定)
        if @lecture_name
          if teacher = Teacher.find_by(name: @teacher_name)
            Lecture.create!(name: @lecture_name, user_id: 1, teacher_id: teacher.id) # 失敗した際にエラーが出るようにする必要あり、最後にセーブ持っていってトランザクションまとめるのもあり。
          else
            teacher = Teacher.new(name: @teacher_name, user_id: 1)
            teacher.save! # if文を用いたほうが良い？
            Lecture.create!(name: @lecture_name, user_id: 1, teacher_id: teacher.id)
          end
        end
      rescue
        # エラーが出た際に何行目でエラーが出たかを表示する
        raise $!, "#{file.path} の #{row_number} 行目を処理中にエラーが発生しました。\n#{$!.message}", $!.backtrace
      end
    end
  end
end
