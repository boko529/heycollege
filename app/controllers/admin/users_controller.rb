class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  def index
    @users = User.all
  end

  # herokuで既存のユーザーにinitポイントを付与するためだけのアクション(1度限りで用済みになります)
  def set_init_point
    User.all.each do |user|
      if user.user_point.blank?
        user.initial_point
      end
    end
    flash[:success] = "initポイントを付与しました。"
    redirect_to root_path
  end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
