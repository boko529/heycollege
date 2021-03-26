module UsersHelper
  def current_user?(user)
    user && user == current_user
  end

  # ユーザーが退会してなかったらユーザー名、退会していたら退会済みと表示
  def u_display_name(user)
    if user.is_deleted
      "退会済み"
    else
      user.name
    end
  end
end
