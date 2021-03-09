class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: [:follow, :unfollow]
  # フォローする
  def follow
    current_user.follow(params[:id])
    @user = User.find(params[:id])
    current_user.create_notification_follow(@user)
    redirect_to user_path(@user.id)
  end

  # アンフォローする
  def unfollow
    current_user.unfollow(params[:id])
    @user = User.find(params[:id])
    redirect_to user_path(@user.id)
  end
end
