class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :update, :destroy]
  before_action :admin_group, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(name: group_params[:name])
    if @group.save
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
    if @group.update(name: group_params[:name])
      flash[:success] = "団体情報は更新されました！"
      redirect_to @group
    else
      render 'edit'
    end
  end

  private
    def group_params
      params.require(:group).permit(:name)
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
