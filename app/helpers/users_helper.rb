module UsersHelper
  def current_user?(user)
    user && user == current_user
  end

  #サイズ変更できるようにした
  def gravatar_for(user, size)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=identicon"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
