class UserPoint < ApplicationRecord
  belongs_to :user
  has_many :user_point_history, dependent: :destroy
  validates :user_id, presence: true
  validates :current_point, presence: true
  validates :total_point, presence: true
end
