class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  def index
    @users = User.where(university_id: current_user.university_id).includes([:user_point]).page(params[:page]).per(30)
  end

  def admin_home
  end

  def analytics
    @opu_users_count = Opu::User.count
    @reviews_count = Review.count
    @apu_users_count = Apu::User.count
    @opu_new_user_counts = [1,2,3,4,5].map do |n|
      Opu::User.where(created_at: n.day.ago.all_day).count
    end

    @apu_new_user_counts = [1,2,3,4,5].map do |n|
      Apu::User.where(created_at: n.day.ago.all_day).count
    end
  end

  # メール作成用
  def prepare_mail
  end

  # apu全体に送信用
  def apu_mail
    @users = Apu::User.all
    @users.each do |user|
        UserMailer.send_mail(user).deliver_now
        # format.json { render :show, status: :created, location: user }
        # format.html { redirect_to root_path }
    end
    redirect_to root_path
  end

  # test送信(マサキのメアド用)
  def test_mail
    @user = User.first
    UserMailer.test_mail(@user).deliver_now
    # format.html { redirect_to root_path }
    # format.json { render :show, status: :created, location: @user }
    redirect_to root_path
  end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
end
