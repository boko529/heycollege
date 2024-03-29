class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :edit_admin, :update_admin, :edit_confirmaiton, :confirm]
  before_action :admin_group, only: [:edit, :update, :edit_admin, :update_admin, :edit_confirmation, :confirm]
  before_action :barrier_confirm, only: [:edit, :update, :edit_admin, :update_admin, :edit_confirmation, :confirm]
  # before_action :check_university, only: [:show] # editなどはバリアユーザーがかかってるので問題ないでしょう
  before_action :barrier_leave, only: [:edit, :update, :edit_admin, :update_admin, :edit_confirmation, :confirm]

  def index
    if user_signed_in?
      @groups = Group.where(university_id: current_user.university_id).includes(:group_point).order("group_points.current_point DESC")
      @slides = SlideContent.where(university_id: current_user.university.id).order(updated_at: :desc) # スライドショー
    else
      @groups = Group.where(university_id: session[:university_id]).includes(:group_point).order("group_points.current_point DESC")
      @slides = SlideContent.where(university_id: session[:university_id]).order(updated_at: :desc) # スライドショー
    end
    @groups = Kaminari.paginate_array(@groups).page(params[:group_page]).per(20)
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
    @members = Array.new
    if @group.twitter_name.present? && @group.instagram_name.present?
      @twitter = "https://twitter.com/"+@group.twitter_name
      @instagram = "https://instagram.com/"+@group.instagram_name
    elsif @group.twitter_name.present?
      @twitter = "https://twitter.com/"+@group.twitter_name
    elsif @group.instagram_name.present?
      @instagram = "https://instagram.com/"+@group.instagram_name
    end
    if user_signed_in?
      @relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: @group.id)
      @users.each do |user|
        relation = UserGroupRelation.find_by(user_id: user.id, group_id: @group.id)
        if relation.confirmation == true && relation.leave == false
          @members.push(user)
        end
      end
      # @users = Kaminari.paginate_array(@users).page(params[:user_page]).per(10)
      @members = Kaminari.paginate_array(@members).page(params[:user_page]).per(10)
    end
  end

  # 管理者にしか作れなくした
  # def new
  #   @group = Group.new
  # end

  # def create
  #   @group = Group.new(name: group_params[:name])
  #   if @group.save
  #     # ポイントテーブル作成+初期ポイント付与
  #     @group.initial_point
  #     UserGroupRelation.create(user_id: current_user.id, group_id: @group.id, admin: true)
  #     flash[:success] = "団体ページ作成しました"
  #     redirect_to @group
  #   else
  #     render 'new'
  #   end
  # end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      # flash[:success] = "団体情報が更新されました！"
      redirect_to @group
    else
      render 'edit'
    end
  end

  def edit_admin
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def update_admin
    @group = Group.find(params[:id])
    @user = User.find_by(id: params[:user_id])
    if relation = UserGroupRelation.find_by(user_id: @user.id, group_id: @group.id)
      relation.admin = true
      relation.save
      flash[:success] = "#{@user.name}さんに編集権を付与しました。"
      redirect_to @group
    end
  end

  def edit_confirmation
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def confirm
    @group = Group.find(params[:id])
    @user = User.find_by(id: params[:user_id])
    if relation = UserGroupRelation.find_by(user_id: @user.id, group_id: @group.id)
      relation.confirmation = true
      relation.save
      flash[:success] = "#{@user.name}さんの参加を承認しました。"
      redirect_to @group
    end
  end


  private
    def group_params
      params.require(:group).permit(:name, :instagram_name, :twitter_name, :profile, :profile_image, :profile_image_cache, :remove_profile_image, :header_image, :header_image_cache, :remove_header_image)
    end

    def admin_group
      group = Group.find(params[:id])
      if user_group_relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
        redirect_to(group) unless user_group_relation.admin?
      else
        redirect_to(group)
      end
    end

    def barrier_confirm
      group = Group.find(params[:id])
      if user_group_relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
        redirect_to(group) unless user_group_relation.confirmation == true
      else
        redirect_to(group)
      end
    end

    # def check_university
    #   @group = Group.find(params[:id])
    #   if current_user.university_id != @group.university_id
    #     redirect_back(fallback_location: root_path)
    #   end
    # end

    def barrier_leave
      group = Group.find(params[:id])
      if user_group_relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
        redirect_to(group) unless user_group_relation.leave == false
      else
        redirect_to(group)
      end
    end

end
