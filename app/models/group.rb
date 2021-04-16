class Group < ApplicationRecord
  # Point関係のメソッドはgroup/point.rbに記載
  include Group::Point
  validates :name, presence: true, uniqueness: {scope: :university_id } # 大学内で同じ名前は一つまで
  has_many :passive_relations, class_name: "UserGroupRelation",
                               foreign_key: "group_id",
                               dependent:   :destroy
  has_many :users, through: :passive_relations, dependent:   :destroy
  has_one :group_point, dependent: :destroy
  has_many :group_point_history, dependent: :destroy
  belongs_to :university
  # has_one :group_profile, dependent: :destroy
  mount_uploader :profile_image, GroupProfileImageUploader
  mount_uploader :header_image, GroupHeaderImageUploader
  validates :twitter_name, length: { maximum: 30}
  validates :instagram_name, length: { maximum: 30}
  validates :profile, length: { maximum: 1000 }
  validates :university_id, presence: true

  def create_notification_join_request!(current_user)
    # hosts = UserGroupRelation.where(group_id: self.id, confirmation: true, admin: true, leave: false) # グループに所属しているユーザーから承認済みで退会していなくかつ、adminのユーザーを配列で取る
    hosts = UserGroupRelation.where(["group_id = ? and confirmation = ? and admin = ? and leave = ?", self.id, true, true, false]) # グループに所属しているユーザーから承認済みで退会していなくかつ、adminのユーザーを配列で取る
    hosts.each do |host|
      temp = Notification.where(["visitor_id = ? and visited_id = ? and group_id = ? and action = ? ", current_user.id, host.id, self.id, 'join_request']) # すでに「送信されているか確認」
      if temp.blank?
        notification = current_user.active_notifications.new(
          group_id: self.id,
          visited_id: host.id
          action: 'join_request'
        )
        notification.save if notification.valid?
      end
    end
  end
end