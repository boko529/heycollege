# ユーザーモデルのポイント関係のメソッドはここに書いていきます。
module User::Point
  extend ActiveSupport::Concern

  # ポイント獲得の処理
  def point_get(amount: , point_type:)
    # トランザクションを用いることで履歴だけ作られるor履歴のみ作られない対策
    ActiveRecord::Base.transaction do
      get_point = self.user_point_history.build(amount: amount, point_type: point_type, user_point_id: self.user_point.id)
      # UserPointHistoryを作成できるかで条件分岐
      if get_point.save
        current_point = self.user_point.current_point
        total_point = self.user_point.total_point
        # UserPointを作成できないときに限りflashメッセージを表示
        unless self.user_point.update(current_point: current_point + amount, total_point: total_point + amount)
          flash[:danger] = "ポイント獲得に失敗しました"
        end
      else
        flash[:danger] = "条件が不適です"
      end
    end
  end

  #ポイント使用,amountは正の値,ポイント使用する所でif文を用いて呼び出して。
  def point_use(amount: , point_type: )
    # トランザクションを用いることで履歴だけ作られるor履歴のみ作られない対策
    ActiveRecord::Base.transaction do
      b_point = self.user_point.current_point
      if b_point >= amount
        use_point = self.user_point_history.build(amount: -amount, point_type: point_type, user_point_id: self.user_point.id)
        if use_point.save
          a_point = b_point - amount
          unless self.user_point.update(current_point: a_point)
            flash[:danger] = "ポイント利用に失敗しました"
            # ポイントを利用する処理をしないで終了
            return false
          end
        else
          flash[:danger] = "条件が不適です"
          redirect_back(fallback_location: root_path)
          # ポイントを使用する処理をしないで終了
          return false
        end
      else
        flash[:danger] = "ポイントが足りません"
        redirect_back(fallback_location: root_path)
        # ポイントが足りないで処理を終了
        return false
      end
    end
  end

  # ユーザーを新規作成した際のポイントテーブル作成 + 初期ポイント発行はdevises/registrations_controllerに記載

  # 参考になるを押された際のメソッド
  def helpfuled_point
    self.point_get(amount: 10, point_type: 1)
  end
end