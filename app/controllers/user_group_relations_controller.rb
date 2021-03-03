class UserGroupRelationsController < ApplicationController
  before_action :authenticate_user!

  def create
    group = Group.find(params[:group_id])
    current_user.join(group)
    redirect_to group
  end

  def destroy
    group = UserGroupRelation.find(params[:id]).group
    current_user.unjoin(group)
    redirect_to group
  end
end
