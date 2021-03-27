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
        # "分野を指定"
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
        else
          field = "APS"
        end
        # 言語を指定
        case row["言語"]
        when "J" then
          language = "ja"
        when "E" then
          language = "en"
        when "Es" then
          language = "es"
        when "E/J" then
          language = "ej"
        else
          # ここまで来るということは分野は言語なので講義名から判断
          if lecture_name_ja.include?("日本語")
            language = "ja"
          elsif lecture_name_ja.include?("英語")
            language = "en"
          elsif lecture_name_ja.include?("スペイン語")
            language = "es"
          elsif lecture_name_ja.include?("韓国語")
            language = "ko"
          elsif lecture_name_ja.include?("中国語")
            language = "zh"
          elsif lecture_name_ja.include?("マレーシア語・インドネシア語")
            language = "ms"
          elsif lecture_name_ja.include?("タイ語")
            language = "th"
          elsif lecture_name_ja.include?("ベトナム語")
            language = "vi"
          end
        end

        # 期間によって場合分けをして機関と曜日と時限を指定
        case row["期間"]
        when "Semester" then
          lecture_term = "First"
        when "1Q" then
          lecture_term = "Q1"
        when "2Q" then
          lecture_term = "Q2"
        when "Session1" then
          lecture_term = "session1"
        end

        # 曜日を指定
        if row["曜日"].include?("月")
          day_of_week = "Mon"
        elsif row["曜日"].include?("火")
          day_of_week = "Tue"
        elsif row["曜日"].include?("水")
          day_of_week = "Wed"
        elsif row["曜日"].include?("木")
          day_of_week = "Thu"
        elsif row["曜日"].include?("金")
          day_of_week = "Fri"
        else
          day_of_week = "Other"
        end

        # 時間を指定
        if row["時限"].include?("1")
          period = "first"
        elsif row["時限"].include?("2")
          period = "second"
        elsif row["時限"].include?("3")
          period = "third"
        elsif row["時限"].include?("4")
          period = "fourth"
        elsif row["時限"].include?("5")
          period = "fifth"
        elsif row["時限"].include?("6")
          period = "sixth"
        else
          period = "none"
        end

        # 以上をもとに作成開始
        if teacher = Teacher.find_by(name_ja: teacher_name_ja) || teacher = Teacher.find_by(name_en: teacher_name_en)
          Lecture.create!(name_ja: lecture_name_ja, name_en: lecture_name_en, user_id: 1, teacher_id: teacher.id, lecture_lang: language, field: field, lecture_term: lecture_term, day_of_week: day_of_week, period: period)
        else
          teacher = Teacher.create!(name_ja: teacher_name_ja, name_en: teacher_name_en, user_id: 1)
          Lecture.create!(name_ja: lecture_name_ja, name_en: lecture_name_en, user_id: 1, teacher_id: teacher.id, lecture_lang: language, field: field, lecture_term: lecture_term, day_of_week: day_of_week, period: period)
        end
      rescue
        # エラーが出た際に何行目でエラーが出たかを表示する
        raise $!, "#{file.path} の #{row_number} 行目を処理中にエラーが発生しました。\n#{$!.message}", $!.backtrace
      end
    end
  end
end
