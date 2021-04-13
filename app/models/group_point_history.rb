class GroupPointHistory < ApplicationRecord
  belongs_to :group
  belongs_to :group_point
  validates :group_id, presence: true
  validates :group_point_id, presence: true
  validates :amount, presence: true
  validates :point_type, presence: true
  enum point_type: { init: 0, helpfuled: 1, helpfuled_lecture: 2, helpfuled_teacher: 3, review: 4, review_d: 5, zoom_a: 6, zoom_h: 7 }, _prefix: :true
end
