module TeachersHelper
   # 言語に合わせて表示するカラムを指定
   def t_display_name(teacher)
    if session[:locale] == "ja" || session[:locale].blank? # セッションが日本語
      teacher.name_ja
    elsif session[:locale] == "en" # セッションが英語
      teacher.name_en
    end
  end
end
