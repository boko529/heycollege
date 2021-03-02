class UserPoint < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :current_point, presence: true
  validates :total_point, presence: true
end
