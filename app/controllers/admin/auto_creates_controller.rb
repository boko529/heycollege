class Admin::AutoCreatesController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  
  def new
  end

  def create
  end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
