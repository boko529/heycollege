class AutoCreate < ApplicationRecord
  # ログのように使います
  validates :name, presence: true

  def self.import_APU(file)
    # CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', headers: true).with_index(2) do |row, row_number|
    # 文字コードの関係でAPUのCSVは文字コードをANSIに一度変換しないといけない
    CSV.foreach(file.path, encoding: 'cp932:UTF-8', headers: true).with_index(2) do |row, row_number|
      begin
        # 名前が英語だったら小文字にして半角スペースで分割、その後各々を1文字目だけ大きくして一つに結合(半角スペースを利用)
        teacher_name_ja = row["先生"].downcase.split.map do |a|
          a.capitalize
        end.join(' ')
        teacher_name_en = row["Teacher"].downcase.split.map do |a|
          a.capitalize
        end.join(' ')
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
          elsif lecture_name_ja.include?("マレー語")
            language = "ms"
          elsif lecture_name_ja.include?("タイ語")
            language = "th"
          elsif lecture_name_ja.include?("ベトナム語")
            language = "vi"
          elsif lecture_name_ja.include?("国連公用語")
            language = "none"
          end
        end

        # # 期間によって場合分けをして機関と曜日と時限を指定
        # case row["期間"]
        # when "Semester" then
        #   lecture_term = "First"
        # when "1Q" then
        #   lecture_term = "Q1"
        # when "2Q" then
        #   lecture_term = "Q2"
        # when "Session1" then
        #   lecture_term = "session1"
        # end

        # # 曜日を指定
        # if row["曜日"].include?("月")
        #   day_of_week = "Mon"
        # elsif row["曜日"].include?("火")
        #   day_of_week = "Tue"
        # elsif row["曜日"].include?("水")
        #   day_of_week = "Wed"
        # elsif row["曜日"].include?("木")
        #   day_of_week = "Thu"
        # elsif row["曜日"].include?("金")
        #   day_of_week = "Fri"
        # else
        #   day_of_week = "Other"
        # end

        # # 時間を指定
        # if row["時限"].include?("1")
        #   period = "first"
        # elsif row["時限"].include?("2")
        #   period = "second"
        # elsif row["時限"].include?("3")
        #   period = "third"
        # elsif row["時限"].include?("4")
        #   period = "fourth"
        # elsif row["時限"].include?("5")
        #   period = "fifth"
        # elsif row["時限"].include?("6")
        #   period = "sixth"
        # else
        #   period = "none"
        # end

        # 以上をもとに作成開始
        if teacher = Teacher.find_by(name_ja: teacher_name_ja, university_id: 1) || teacher = Teacher.find_by(name_en: teacher_name_en, university_id: 1)
          unless Lecture.find_by(name_ja: lecture_name_ja, teacher_id: teacher.id, university_id: 1) || Lecture.find_by(name_en: lecture_name_en, teacher_id: teacher.id, university_id: 1) # APU内で先生と日本語名がおなじか先生と英語名が同じの時以外
            Apu::Lecture.create!(name_ja: lecture_name_ja, name_en: lecture_name_en, user_id: 1, teacher_id: teacher.id, lecture_lang: language, field: field, university_id: 1)
          end
        else
          teacher = Teacher.create!(name_ja: teacher_name_ja, name_en: teacher_name_en, user_id: 1, university_id: 1)
          Apu::Lecture.create!(name_ja: lecture_name_ja, name_en: lecture_name_en, user_id: 1, teacher_id: teacher.id, lecture_lang: language, field: field, university_id: 1)
        end
      rescue
        # エラーが出た際に何行目でエラーが出たかを表示する
        raise $!, "#{file.path} の #{row_number} 行目を処理中にエラーが発生しました。\n#{$!.message}", $!.backtrace
      end
    end
  end

  def self.import_OPU(file)
    # 文字コードの関係でAPUのCSVは文字コードをANSIに一度変換しないといけない
    CSV.foreach(file.path, headers: true).with_index(2) do |row, row_number|
      begin
        teacher_name = row["教員名"].gsub(" ", "") # 読み込んで半角スペース削除
        lecture_name = row["授業名"].sub(/\(.+\)/, "").sub(/\（.+\）/, "").sub(/\<.+\>/, "")
        if row["期間"].include?("前期授業")
          semester = "fir_seme"
        elsif row["期間"].include?("後期授業")
          semester = "sec_seme"
        elsif row["期間"].include?("通年授業")
          semester = "total_seme"
          day_of_week = "out"
        elsif row["期間"].include?("前期集中")
          semester = "fir_session"
          day_of_week = "out"
        elsif row["期間"].include?("後期集中")
          semester = "sec_session"
          day_of_week = "out"
        end

        if row["曜日"].include?("月曜")
          day_of_week = "mon"
        elsif row["曜日"].include?("火曜")
          day_of_week = "tue"
        elsif row["曜日"].include?("水曜")
          day_of_week = "wed"
        elsif row["曜日"].include?("木曜")
          day_of_week = "thu"
        elsif row["曜日"].include?("金曜")
          day_of_week = "fri"
        elsif row["曜日"].include?("土曜")
          day_of_week = "sat"
        elsif row["曜日"].include?("日曜")
          day_of_week = "sun"
        end

        if row["コマ"].include?("１コマ")
          period = "first"
        elsif row["コマ"].include?("２コマ")
          period = "second"
        elsif row["コマ"].include?("３コマ")
          period = "third"
        elsif row["コマ"].include?("４コマ")
          period = "fourth"
        elsif row["コマ"].include?("５コマ")
          period = "fifth"
        elsif row["コマ"].include?("６コマ")
          period = "sixth"
        end

        case row["分類"]
        when "英語" then
          field = "Syozemi"
        when "英語" then
          field = "Pankyo"
        when "外国語科目（英語）" then
          field = "English"
        when "英語" then
          field = "Shogai"
        when "英語" then
          field = "Gaikokugotokubetu"
        when "英語" then
          field = "Kaigaikensyu"
        when "健康・スポーツ科学科目" then
          field = "Kenkou"
        when "英語" then
          field = "Zyouhou"
        when "英語" then
          field = "Iryo"
        when "英語" then
          field = "Senmon"
        when "英語" then
          field = "Tokurei"
        when "理系基礎" then
          field = "Sikaku"
        when "専門" then
          field = "Rikeikiso"
        end
        
        # 以上をもとに作成開始
        if teacher = Teacher.find_by(name_ja: teacher_name, university_id: 2) # OPUは英語名と日本語名同じなので日本語のほうで条件分岐
          if lecture = Opu::Lecture.find_by(name_ja: lecture_name, teacher_id: teacher.id, university_id: 2)
            unless LectureInfo.find_by(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period,lecture_id: lecture.id)
              LectureInfo.create!(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period, lecture_id: lecture.id)
            end
          else
            lecture = Opu::Lecture.create!(name_ja: lecture_name, name_en: lecture_name, user_id: 1, teacher_id: teacher.id, field: field, university_id: 2)
            LectureInfo.create!(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period, lecture_id: lecture.id)
          end
        else
          #先生を作成
          teacher = Teacher.create!(name_ja: teacher_name, name_en: teacher_name, user_id: 1, university_id: 2)
          #クラスの大本情報(分類、先生、クラス名)
          lecture = Opu::Lecture.create!(name_ja: lecture_name, name_en: lecture_name, user_id: 1, teacher_id: teacher.id, field: field, university_id: 2)
          # 時間割や学類などのたくさんある情報シラバス
          LectureInfo.create!(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period, lecture_id: lecture.id)
        end
      rescue
        # エラーが出た際に何行目でエラーが出たかを表示する
        raise $!, "#{file.path} の #{row_number} 行目を処理中にエラーが発生しました。\n#{$!.message}", $!.backtrace
      end
    end
  end
end
