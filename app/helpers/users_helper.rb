module UsersHelper
  def current_user?(user)
    user && user == current_user
  end

  def display_name(user)
    if user.is_deleted
      "退会済み"
    else
      user.name
    end
  end
end
