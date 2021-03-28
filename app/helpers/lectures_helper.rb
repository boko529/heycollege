module LecturesHelper
  # 言語に合わせて表示するカラムを指定
  def l_display_name(lecture)
    if session[:locale] == "ja" || session[:locale].blank? # セッションが日本語
      lecture.name_ja.present? ? lecture.name_ja : lecture.name_en # 日本語名があったら日本語名なかったら英語名で表示
    elsif session[:locale] == "en" # セッションが英語
      lecture.name_en.present? ? lecture.name_en : lecture.name_ja # 英語名があったら英語名なかったら日本語名で表示
    end
  end
end