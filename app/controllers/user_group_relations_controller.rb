class UserGroupRelationsController < ApplicationController
  before_action :authenticate_user!

  def create
    group = Group.find(params[:group_id])
    if relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
      relation.leave = false
    else
      current_user.join(group)
    end
    flash[:success] = "#{current_user.name}さんは#{group.name}に参加しました!"
    redirect_to group
  end

  def leave
    relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: params[:group_id])
    group = relation.group
    relations = UserGroupRelation.where(group_id: group.id)
    if relation.admin == true # 自分が管理者のとき
      if admincount(relations) >= 2 #自分ともう1人(以上)管理者が存在する場合
        # current_user.unjoin(group)
        relation.leave = true
        flash[:success] = "#{current_user.name}さんは#{group.name}から退会しました!"
        redirect_to group
      else
        flash[:alert] = "他のメンバーに管理者権限を許可してください。"
        redirect_to group
      end
    else # 自分が管理者でないとき
      # この場合、必ず管理者が他に存在するので条件分岐なし.
      # current_user.unjoin(group)
      relation.leave = true
      flash[:success] = "#{current_user.name}さんは#{group.name}から退会しました!"
      redirect_to group
    end  
  end

  private
    def admincount(relations)
      if relations.present?
        admin_user_count = 0
        relations.each do |relation|
          if relation.admin == true
            admin_user_count += 1
          end
        end
        return admin_user_count
      else
        return 0
      end
    end

end
