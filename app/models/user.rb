class User < ApplicationRecord
  # Point関係のメソッドはuser/point.rbに記載
  include User::Point
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum grade: { B1: 1, B2: 2, B3: 3, B4: 4}, _prefix: :true
  enum gender: { male: 1,  female: 2 }, _prefix: :true
  enum faculty: { APS: 1, APM: 2}, _prefix: :true
  #開発の都合でユーザー破壊されたらデータも破壊、後々改善する必要あり
  has_many :lectures, dependent: :destroy
  has_many :reviews
  has_many :helpfuls
  has_many :teachers, dependent: :destroy   #  dependentは削除する可能性あり.
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  has_one :user_point, dependent: :destroy
  has_many :user_point_history, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :active_relations, class_name:  "UserGroupRelation",
  foreign_key: "user_id"
  has_many :group, through: :active_relations
  has_many :follower, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followed, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  # APUメアドのバリデーション削除
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@apu.ac.jp\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true, length: { minimum: 2, maximum: 20}
  validates :message, length: { maximum: 100 }
  validates :twitter_name, length: { maximum: 30}
  validates :instagram_name, length: { maximum: 30}

  
  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  
  # ユーザーをアンフォローする
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  
  # フォローしているかを確認する
  def following?(user)
    following_user.include?(user)
  end
  
  # フォローした際に通知を発行
  def create_notification_follow(followed_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", self.id, followed_user.id, 'follow'])
    # 既に通知が存在するか確認,通知がない場合のみ送信
    if temp.blank?
      notification = self.active_notifications.new(
        visited_id: followed_user.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def join(group1)
    group << group1
  end

  def unjoin(group1)
    active_relations.find_by(group_id: group1.id).destroy
  end

  # groupに参加しているかどうかを確認する
  def belongs?(group1)
    group.include?(group1)
  end

  # 退会済みかどうか確認(退会済みならtrue)
  def active_for_authentication?
    super && (self.is_deleted == false)
  end
end