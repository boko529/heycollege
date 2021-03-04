class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :update, :destroy, :users]

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

  def users
    @title = "Members"
    @group  = Group.find(params[:id])
    @users = @group.users
    render 'show_users'
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end

end
