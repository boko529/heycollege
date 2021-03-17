class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:follow, :unfollow]
  # フォローする
  def follow
    current_user.follow(params[:id])
    @user = User.find(params[:id])
    current_user.create_notification_follow(@user)
    # 非同期通信後でページ遷移(redirect_to)があるとうまくいかない(turbolinksをoffにしている場合)
    # redirect_to user_path(@user.id)
    # コントローラーの名前とviewがあるディレクトリの名前が違うので明示的に示さないといけない
    render "users/follow"
  end

  # アンフォローする
  def unfollow
    current_user.unfollow(params[:id])
    @user = User.find(params[:id])
    # 非同期通信後でページ遷移(redirect_to)があるとうまくいかない(turbolinksをoffにしている場合)
    # redirect_to user_path(@user.id)
    # コントローラーの名前とviewがあるディレクトリの名前が違うので明示的に示さないといけない
    render "users/unfollow"
  end
end
