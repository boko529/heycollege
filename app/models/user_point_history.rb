class UserPointHistory < ApplicationRecord
  belongs_to :user
  belongs_to :user_point
  validates :user_id, presence: true
  validates :user_point_id, presence: true
  validates :amount, presence: true
  validates :point_type, presence: true
  enum point_type: { init: 0, helpfuled: 1, helpfuled_lecture: 2, helpfuled_teacher: 3 }, _prefix: :true
end
