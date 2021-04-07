class UserGroupRelationsController < ApplicationController
  before_action :authenticate_user!

  def create
    group = Group.find(params[:group_id])
    if relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: group.id)
      relation.leave = false
      relation.save
    else
      current_user.join(group)
    end
    # flash[:success] = "#{current_user.name}さんは#{group.name}に参加しました!"
    flash[:success] = "Joinリクエストを送信しました！ホストからの承認をお待ち下さい。"
    redirect_to group
  end

  def leave
    relation = UserGroupRelation.find_by(user_id: current_user.id, group_id: params[:group_id])
    group = Group.find_by(id: params[:group_id])
    relations = UserGroupRelation.where(group_id: group.id)
    if relation.confirmation == true
      if relation.admin == true # 自分が管理者のとき
        if admincount(relations) >= 2 #自分ともう1人(以上)管理者が存在する場合
          # current_user.unjoin(group)
          relation.leave = true
          relation.save
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
        relation.save
        flash[:success] = "#{current_user.name}さんは#{group.name}から退会しました!"
        redirect_to group
      end
    else
      current_user.unjoin(group) # そもそもconfirmされてないユーザーはunjoinでいい.
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
