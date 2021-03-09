class Helpful < ApplicationRecord
  belongs_to :review
  belongs_to :user

  validates_uniqueness_of :review_id, scope: :user_id

  # 参考になるを押された際に通知を発行するメソッド
  def create_notification_helpful!(current_user)
    review = self.review
    # すでに「参考になる」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and review_id = ? and action = ? ", current_user.id, review.user_id, review.id, 'helpful'])
    # 参考になるされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        review_id: review.id,
        visited_id: review.user_id,
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
