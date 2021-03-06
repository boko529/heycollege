class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :update, :destroy]

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
      # ポイントテーブル作成+初期ポイント付与
      @group.initial_point
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

end
