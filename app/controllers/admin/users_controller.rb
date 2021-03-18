class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  def index
    @users = User.all
  end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
