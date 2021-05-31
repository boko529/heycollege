module ApplicationHelper
  def d_university_id
    if user_signed_in?
      current_user.university_id
    elsif session[:university_id]
      session[:university_id].to_i # セッションがなかったらbeforeアクションで弾かれてるはず！！
    end
  end
end
