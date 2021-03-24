class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :update, :edit_admin, :update_admin]
  before_action :admin_group, only: [:edit, :update, :edit_admin, :update_admin]

  def index
    @groups = Group.all
    @groups = Kaminari.paginate_array(@groups).page(params[:group_page]).per(5)
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
    @relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: @group.id)
    @profile = @group.group_profile
    @users = Kaminari.paginate_array(@users).page(params[:user_page]).per(10)
    if @group.twitter_name.present? && @group.instagram_name.present?
      @twitter = "https://twitter.com/"+@group.twitter_name
      @instagram = "https://instagram.com/"+@group.instagram_name
    elsif @group.twitter_name.present?
      @twitter = "https://twitter.com"+@group.twitter_name
    elsif @group.instagram_name.present?
      @instagram = "https://instagram.com"+@group.instagram_name
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(name: group_params[:name])
    if @group.save
      # ポイントテーブル作成+初期ポイント付与
      @group.initial_point
      UserGroupRelation.create(user_id: current_user.id, group_id: @group.id, admin: true)
      flash[:success] = "団体ページ作成しました"
      redirect_to @group
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      flash[:success] = "団体情報は更新されました！"
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


  private
    def group_params
      params.require(:group).permit(:name, :instagram_name, :twitter_name, :profile_image, :profile_image_cache, :remove_profile_image)
    end

    def admin_group
      group = Group.find(params[:id])
      if user_group_relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
        redirect_to(group) unless user_group_relation.admin?
      else
        redirect_to(group)
      end
    end

end
