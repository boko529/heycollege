class AutoCreate < ApplicationRecord
  # ログのように使います
  validates :name, presence: true

  def self.import_APU(file)
    # CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true).with_index(2) do |row, row_number|
    # 文字コードの関係でAPUのCSVは文字コードをANSIに一度変換しないといけない
    CSV.foreach(file.path, encoding: 'cp932:UTF-8', headers: true).with_index(2) do |row, row_number|
      begin
        teacher_name_ja = row["先生"]
        teacher_name_en = row["Teacher"]
        lecture_name_ja = row["講義"].sub(/^\w+\)/, "") # 講義名の冒頭の"Online)"や"Hyblid)"などの")"手前を削除(正規表現で指定)
        lecture_name_en = row["Lecture"].sub(/^\w+\)/, "") # 講義名の冒頭の"Online)"や"Hyblid)"などの")"手前を削除(正規表現で指定)
        # "分野の値によって条件分岐"
        case row["分野"]
        when "APS" then
          field = "APS"
        when "APM" then
          field = "APM"
        when "APS APM" then
          field = "APSAPM"
        when "Liberal Arts" then
          field = "Liberal"
        when "Language" then
          field = "Language"
        end
        case row["言語"]
        when "J" then
          language = "Ja"
        when "E" then
          language = "En"
        when "Es" then
          language = "Es"
        when "E/J" then
          language = "EJ"
        else
          # 分野が言語ということなので分野名と統一して代入考える？
        end
        if teacher = Teacher.find_by(name_ja: teacher_name_ja) || teacher = Teacher.find_by(name_en: teacher_name_en)
          Lecture.create!(name_ja: lecture_name_ja, name_en: lecture_name_en, user_id: 1, teacher_id: teacher.id, lecture_lang: language, field: field)
        else
          teacher = Teacher.create!(name_ja: teacher_name_ja, name_en: teacher_name_en, user_id: 1)
          Lecture.create!(name_ja: lecture_name_ja, name_en: lecture_name_en, user_id: 1, teacher_id: teacher.id, lecture_lang: language, field: field)
        end
      rescue
        # エラーが出た際に何行目でエラーが出たかを表示する
        raise $!, "#{file.path} の #{row_number} 行目を処理中にエラーが発生しました。\n#{$!.message}", $!.backtrace
      end
    end
  end
end
