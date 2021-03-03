class RelationshipsController < ApplicationController
  # フォローする
  def follow
    current_user.follow(params[:id])
    @user = User.find(params[:id])
    redirect_to user_path(@user.id)
  end

  # アンフォローする
  def unfollow
    current_user.unfollow(params[:id])
    @user = User.find(params[:id])
    redirect_to user_path(@user.id)
  end
end
