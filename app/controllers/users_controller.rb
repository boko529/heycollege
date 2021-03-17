class UsersController < ApplicationController   
  before_action :authenticate_user!, only: [:edit,:update,:show,:following,:follower, :hide]
  before_action :user_is_not_deleted_show, only: [:show]
  before_action :user_is_not_deleted_follow, only: [:following, :follower]
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.includes(lecture: :teacher).page(params[:reviews_page]).per(10)
    @lectures = @user.lectures.includes(:reviews, :teacher).page(params[:lectures_page]).per(20)
    @groups = @user.group
    if @user.twitter_name.present? && @user.instagram_name.present?
      @twitter = "https://twitter.com/"+@user.twitter_name
      @instagram = "https://instagram.com/"+@user.instagram_name
    elsif @user.twitter_name.present?
      @twitter = "https://twitter.com/"+@user.twitter_name
    elsif @user.instagram_name.present?
      @instagram = "https://instagram.com/"+@user.instagram_name
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render 'edit'
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:notice] = "プロフィールを変更しました"
    else
      render 'edit'
    end
  end

  # 自分がフォローしているユーザー一覧
  def following
    @user = User.find(params[:user_id])
    @followings = @user.following_user
  end

  # 自分をフォローしているユーザー一覧
  def follower
    @user = User.find(params[:user_id])
    @followers = @user.follower_user
  end

  # 退会(論理削除)
  def hide
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心からお待ちしております。"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name,:gender,:grade,:faculty, :twitter_name, :instagram_name, :message)
  end

  # 退会しているかを確認(user/show用)
  def user_is_not_deleted_show
    @user = User.find(params[:id])
    if @user.is_deleted
      flash[:notice] = "退会済みユーザーです"
      redirect_to root_path
    end
  end

  # 退会しているかを確認(フォローフォロワーリスト用)idの種類が違うので分けている
  def user_is_not_deleted_follow
    @user = User.find(params[:user_id])
    if @user.is_deleted
      flash[:notice] = "退会済みユーザーです"
      redirect_to root_path
    end
  end
end
