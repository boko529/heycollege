# ユーザーモデルのポイント関係のメソッドはすべてここに書く。
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
        self.user_point.update(current_point: current_point + amount, total_point: total_point + amount)
      else
        return false
      end
    end
  end

  #ポイント使用,amountは正の値,ポイント使用する所でif文を用いて呼び出して(下記コメントの用に)。
  # if @user.point_use(amount: 10, point_type: 3)
  #   # 実行したい処理
  # else
  #   flash[:danger] = "ポイントは足りません"
  # end
  def point_use(amount: , point_type: )
    # トランザクションを用いることで履歴だけ作られるor履歴のみ作られない対策
    ActiveRecord::Base.transaction do
      b_point = self.user_point.current_point
      if b_point >= amount
        use_point = self.user_point_history.build(amount: -amount, point_type: point_type, user_point_id: self.user_point.id)
        if use_point.save
          a_point = b_point - amount
          self.user_point.update(current_point: a_point)
        end
      end
    end
  end

  # ユーザーを新規作成した際のポイントテーブル作成 + 初期ポイント発行
  def initial_point
    self.create_user_point(current_point: 0, total_point: 0)
    self.point_get(amount: 10.0, point_type: 0)
  end

  # 参考になるを押された際にレビュー作成者へのメソッド
  def helpfuled_point
    self.point_get(amount: 100.0, point_type: 1)
  end

  # 参考になるを押された際に講義作成者へのメソッド
  def helpfuled_lecture_point
    self.point_get(amount: 1.0, point_type: 2)
  end

  # 参考になるを押された際に先生作成者へのメソッド
  def helpfuled_teacher_point
    self.point_get(amount: 1.0, point_type: 3)
  end

  # 参考になるを押された際レビュー書き手の団体へのポイント付与
  def group_helpfuled_point
    unless self.group.blank?
      amount = (100.0 / self.group.count).floor(1)
      self.group.each do |group|
        group.point_get(amount: amount, point_type: 1)
      end
    end
  end
  
  # 参考になるを押された際の講義作成者の団体へのポイント付与
  def group_helpfuled_lecture_point
    unless self.group.blank?
      amount = (1.0 / self.group.count).floor(1)
      self.group.each do |group|
        group.point_get(amount: amount, point_type: 2)
      end
    end
  end

  # 参考になるを押された際の先生作成者の団体へのポイント付与
  def group_helpfuled_teacher_point
    unless self.group.blank?
      amount = (1.0 / self.group.count).floor(1)
      self.group.each do |group|
        group.point_get(amount: amount, point_type: 3)
      end
    end
  end
end