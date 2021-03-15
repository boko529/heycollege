class UsersController < ApplicationController   
  before_action :authenticate_user!, only: [:edit,:update,:show,:following,:follower, :hide]
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.includes(lecture: :teacher).page(params[:reviews_page]).per(10)
    @lectures = @user.lectures.includes(:reviews, :teacher).page(params[:lectures_page]).per(20)
    @groups = @user.group
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
    params.require(:user).permit(:name,:gender,:grade,:faculty, :twitter_url, :message)
  end
end
