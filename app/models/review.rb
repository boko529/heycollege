class Review < ApplicationRecord
  belongs_to :user
  belongs_to :lecture
  has_many :helpfuls
  has_many :notifications, dependent: :destroy
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 600 }
  validates :explanation, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :fairness, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :recommendation, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :useful, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :interesting, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :difficulty, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :score, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }

  def average_score
    average_score = ( self.explanation + self.fairness + self.recommendation + self.useful + self.interesting ) / 5
    return average_score.round(2)
  end

  def helpfuled_by?(user)
    helpfuls.where(user_id: user.id).exists?
  end

  def create_notification_helpful!(current_user)
    # すでに「参考になる」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and review_id = ? and action = ? ", current_user.id, user_id, id, 'helpful'])
    # 参考になるされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        review_id: id,
        visited_id: user_id,
        action: 'helpful'
      )
      # 自分の投稿に対する参考になるの場合は、通知済みとする。後々自分に参考になるを押せるようになるかもしれないから書いときます。
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
end
