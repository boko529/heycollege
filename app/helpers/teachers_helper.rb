module TeachersHelper
   # 言語に合わせて表示するカラムを指定
   def t_display_name(teacher)
    if session[:locale] == "ja" || session[:locale].blank? # セッションが日本語
      teacher.name_ja.present? ? teacher.name_ja : teacher.name_en # 日本語名があったら日本語名なかったら英語名で表示
    elsif session[:locale] == "en" # セッションが英語
      teacher.name_en.present? ? teacher.name_en : teacher.name_ja # 英語名があったら英語名なかったら日本語名で表示
    end
  end
end
