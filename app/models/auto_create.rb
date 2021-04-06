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
        teacher_name = row["教員名"].gsub(" ", "").sub(/・.+/, "").sub(/\n.+/, "") # 読み込んで半角スペース削除、"・他"も削除、オムニバスは最初の一人のみ(\n以降を削除)
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

        if row["分類"].include?("初年次ゼミナール")
          field = "Syozemi"
        elsif row["分類"].include?("教養科目")
          field = "Pankyo"
        elsif row["分類"].include?("外国語科目（英語）")
          field = "English"
        elsif row["分類"].include?("初修外国語")
          field = "Shogai"
        elsif row["分類"].include?("外国語特別科目")
          field = "Gaikokugotokubetu"
        elsif row["分類"].include?("海外語学研修科目")
          field = "Kaigaikensyu"
        elsif row["分類"].include?("健康・スポーツ科学科目")
          field = "Kenkou"
        elsif row["分類"].include?("情報基礎科目")
          field = "Zyouhou"
        elsif row["分類"].include?("医療・保険基礎科目")
          field = "Iryo"
        elsif row["分類"].include?("専門科目")
          field = "Senmon"
        elsif row["分類"].include?("特例科目")
          field = "Tokurei"
        elsif row["分類"].include?("資格科目（教職科目）")
          field = "Sikaku"
        elsif row["分類"].include?("理系基礎科目")
          field = "Rikeikiso"
        end

        # syllabus = row["URL"]

        if row["場所"].include?(",オンライン")
          state = "Complex"
        elsif row["場所"].include?("オンライン")
          state = "Online"
        elsif row["場所"].include?("後日提示")
          state = "Unknown"
        else
          state = "Offline"
        end

        if row["学域"] && row["学類"]
          #学域・学類カラムがある
          if row["学域"].include?("現代システム科学域")
            faculty = "Gensisu"
          elsif row["学域"].include?("工学域")
            faculty = "Kougaku"
          elsif row["学域"].include?("生命環境科学域")
            faculty = "Seikan"
          elsif row["学域"].include?("地域保健学域")
            faculty = "Tiiki"
          end

          if row["学類"].include?("電気電子系")
            department = "denden"
          elsif row["学類"].include?("物質科学系")
            department = "bukka"
          elsif row["学類"].include?("機械系")
            department = "kikai"
          elsif row["学類"].include?("獣医")
            department = "juui"
          elsif row["学類"].include?("応用生命")
            department = "ousei"
          elsif row["学類"].include?("緑地")
            department = "ryokuti"
          elsif row["学類"].include?("理学")
            department = "rigaku"
          elsif row["学類"].include?("看護")
            department = "kango"
          elsif row["学類"].include?("総合リハビリテーション")
            department = "rihabiri"
          elsif row["学類"].include?("教育福祉")
            department = "kyouhuku"
          elsif row["学類"].include?("知識情報")
            department = "tijou"
          elsif row["学類"].include?("環境システム")
            department = "kanshisu"
          elsif row["学類"].include?("マネジ")
            department = "maneji"
          end
        end

        if row["課程"]
          if row["課程"].include?("情報工学")
            major = "joukou"
          elsif row["課程"].include?("電気電子システム")
            major = "densisu"
          elsif row["課程"].include?("電子物理")
            major = "denbutu"
          elsif row["課程"].include?("応用化学")
            major = "ouka"
          elsif row["課程"].include?("化学工学")
            major = "kakou"
          elsif row["課程"].include?("マテリアル工学")
            major = "material"
          elsif row["課程"].include?("航空宇宙工学")
            major = "koukuu"
          elsif row["課程"].include?("海洋システム工学")
            major = "kaiyou"
          elsif row["課程"].include?("機械工学")
            major = "kikaikou"
          elsif row["課程"].include?("生命機能化学")
            major = "seimei"
          elsif row["課程"].include?("植物バイオサイエンス")
            major = "shokugutu"
          elsif row["課程"].include?("数理科学")
            major = "suuri"
          elsif row["課程"].include?("物理科学")
            major = "buturi"
          elsif row["課程"].include?("分子科学")
            major = "bunshi"
          elsif row["課程"].include?("生物科学")
            major = "seibutu"
          elsif row["課程"].include?("理学療法")
            major = "rigakuryou"
          elsif row["課程"].include?("作業療法")
            major = "sagyouryou"
          elsif row["課程"].include?("栄養療法")
            major = "eiyouryou"
          elsif row["課程"].include?("環境共生科学")
            major = "kankyou"
          elsif row["課程"].include?("社会共生科学")
            major = "shakyou"
          elsif row["課程"].include?("人間環境科学")
            major = "ninkan"
          end
        end
        
        # 以上をもとに作成開始
        if teacher = Teacher.find_by(name_ja: teacher_name, university_id: 2) # OPUは英語名と日本語名同じなので日本語のほうで条件分岐
          if lecture = Opu::Lecture.find_by(name_ja: lecture_name, teacher_id: teacher.id, university_id: 2, state: state)
            unless LectureInfo.find_by(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period,lecture_id: lecture.id)
              LectureInfo.create!(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period, lecture_id: lecture.id)
            end
          else
            lecture = Opu::Lecture.create!(name_ja: lecture_name, name_en: lecture_name, user_id: 1, teacher_id: teacher.id, field: field, university_id: 2, state: state)
            LectureInfo.create!(faculty: faculty, department: department, major: major, day_of_week: day_of_week, semester: semester, period: period, lecture_id: lecture.id)
          end
        else
          #先生を作成
          teacher = Teacher.create!(name_ja: teacher_name, name_en: teacher_name, user_id: 1, university_id: 2)
          #クラスの大本情報(分類、先生、クラス名)
          lecture = Opu::Lecture.create!(name_ja: lecture_name, name_en: lecture_name, user_id: 1, teacher_id: teacher.id, field: field, university_id: 2, state: state)
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
