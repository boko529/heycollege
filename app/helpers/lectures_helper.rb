module LecturesHelper
  # 言語に合わせて表示するカラムを指定
  def l_display_name(lecture)
    if session[:locale] == "ja" || session[:locale].blank? # セッションが日本語
      lecture.name_ja
    elsif session[:locale] == "en" # セッションが英語
      lecture.name_en
    end
  end
end