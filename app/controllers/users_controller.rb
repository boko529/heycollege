class UsersController < ApplicationController   
  before_action :authenticate_user!, only: [:edit,:update]
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
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

  private
  def user_params
    params.require(:user).permit(:name,:gender,:grade,:faculty)
  end
end
