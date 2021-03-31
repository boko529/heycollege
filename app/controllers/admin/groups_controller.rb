class Admin::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(name: group_params[:name])
    if host = User.find_by(email: group_params[:email])
      if @group.save
        # ポイントテーブル作成+初期ポイント付与
        @group.initial_point
        UserGroupRelation.create(user_id: host.id, group_id: @group.id, admin: true, confirmation: true)
        flash[:success] = "団体ページ作成しました"
        redirect_to @group
      else
        render 'new'
      end
    else
      flash[:danger] = "emailのユーザーが存在しません"
      render 'new'
    end
  end

  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def group_params
    # params.require(:group).permit(:name, :instagram_name, :twitter_name, :profile, :profile_image, :profile_image_cache, :remove_profile_image, :header_image, :header_image_cache, :remove_header_image)
    params.require(:group).permit(:name, :email)
  end
end
