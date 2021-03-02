class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum grade: { B1: 1, B2: 2, B3: 3, B4: 4, M1: 5, M2: 6, D1: 7, D2: 8,D3: 9}, _prefix: :true
  enum gender: { male: 1,  female: 2 }, _prefix: :true
  enum faculty: { APS: 1, APM: 2}, _prefix: :true
  #開発の都合でユーザー破壊されたらデータも破壊、後々改善する必要あり
  has_many :lectures, dependent: :destroy
  has_many :reviews
  has_many :helpfuls
  has_many :teachers, dependent: :destroy   #  dependentは削除する可能性あり.
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  belongs_to :user_points
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true, length: { minimum: 2, maximum: 20}


  include Gravtastic
  gravtastic
end