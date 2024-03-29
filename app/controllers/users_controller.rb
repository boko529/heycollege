class UsersController < ApplicationController   
  before_action :authenticate_user!, only: [:edit,:update,:show,:following,:follower, :hide]
  before_action :user_is_not_deleted_show, only: [:show]
  before_action :user_is_not_deleted_follow, only: [:following, :follower]
  # before_action :check_university_show, only: [:show] # zoomハウスから他大学のユーザーに飛べるためコメントアウト
  before_action :check_university_follow, only: [:following, :follower]

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
      flash[:notice] = t('.updated-user')
    else
      render 'edit'
    end
  end

  def emailedit
    @user = User.find(params[:id])
    if @user == current_user
      render 'emailedit'
    else
      redirect_to user_path(current_user)
    end
  end

  def emailupdate
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to page_path('explain_confirmation')
      flash[:notice] = t('.updated-user')
    else
      render 'emailedit'
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
    flash[:notice] = t('.hide-message')
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name,:gender,:grade,:faculty, :twitter_name, :instagram_name, :zoom_url, :message, :image, :image_cache, :remove_image, :email)
  end

  # 退会しているかを確認(user/show用)
  def user_is_not_deleted_show
    @user = User.find(params[:id])
    if @user.is_deleted
      flash[:notice] = t('.user-hidden')
      redirect_to root_path
    end
  end

  # 退会しているかを確認(フォローフォロワーリスト用)idの種類が違うので分けている
  def user_is_not_deleted_follow
    @user = User.find(params[:user_id])
    if @user.is_deleted
      flash[:notice] = t('.user-hidden')
      redirect_to root_path
    end
  end

  # # 自分と同じ大学のshowページしか見れない
  # def check_university_show
  #   @user = User.find(params[:id])
  #   if current_user.university_id != @user.university_id
  #     redirect_back(fallback_location: root_path)
  #   end
  # end

  # 自分と同じ大学のshowページしか見れない
  def check_university_follow
    @user = User.find(params[:user_id])
    if current_user.university_id != @user.university_id
      redirect_back(fallback_location: root_path)
    end
  end
end
