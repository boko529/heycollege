# グループモデルのポイント関係のメソッドはすべてここに書く
module Group::Point
  extend ActiveSupport::Concern

  # ポイント獲得の処理
  def point_get(amount: , point_type:)
    # トランザクションを用いることで履歴だけ作られるor履歴のみ作られない対策
    ActiveRecord::Base.transaction do
      get_point = self.group_point_history.build(amount: amount, point_type: point_type, group_point_id: self.group_point.id)
      # GroupPointHistoryを作成できるかで条件分岐
      if get_point.save
        current_point = self.group_point.current_point
        total_point = self.group_point.total_point
        self.group_point.update(current_point: current_point + amount, total_point: total_point + amount)
      else
        return false
      end
    end
  end

  # グループを新規作成した際のポイントテーブル作成 + 初期ポイント発行
  def initial_point
    self.create_group_point(current_point: 0, total_point: 0)
    self.point_get(amount: 10, point_type: 0)
  end
end