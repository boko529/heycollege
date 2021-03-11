class GroupProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_group, only: [:new, :create]
  before_action :admin_group_2, only: [:edit, :update, :destroy]

  def new
    @group = Group.find(params[:id])
    @profile = GroupProfile.new
  end

  def create
    @group = Group.find(params[:id])
    # 既にプロフィールを書いているか確認
    unless GroupProfile.find_by(group_id: @group.id)
      @profile = GroupProfile.new(profile_params)
      @profile.group_id = @group.id
      if @profile.save
        flash[:success] = "プロフィールを作成しました"
        # プロフィールをidで指定して表示
        redirect_to @group
      else
        flash[:danger] = "プロフィールを作成に失敗しました"
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:danger] = "すでにプロフィールを作成済みです"
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @profile = GroupProfile.find(params[:id])
  end

  def update
    @profile = GroupProfile.find(params[:id])
    @group = @profile.group
    if @profile.update(profile_params)
      flash[:success] = "団体プロフィールは更新されました！"
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    @profile = GroupProfile.find(params[:id])
    @group = @profile.group
    @profile.destroy
    flash[:success] = "プロフィールを削除しました"
    redirect_to group_path(@group)
  end

  private
    def profile_params
      params.require(:group_profile).permit(:content)
    end

    def admin_group
      group = Group.find(params[:id])
      if user_group_relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
        redirect_to(group) unless user_group_relation.admin?
      else
        redirect_to(group)
      end
    end

    def admin_group_2 # 取得idの違いによる.
      profile = GroupProfile.find(params[:id])
      group = profile.group
      if user_group_relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
        redirect_to(group) unless user_group_relation.admin?
      else
        redirect_to(group)
      end
    end
end
