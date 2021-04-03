class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  def index
    @users = User.where(university_id: current_user.university_id).includes([:user_point]).page(params[:page]).per(30)
  end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
