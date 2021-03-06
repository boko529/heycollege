class GroupPointHistory < ApplicationRecord
  belongs_to :group
  belongs_to :group_point
  validates :group_id, presence: true
  validates :group_point_id, presence: true
  validates :amount, presence: true
  validates :point_type, presence: true
  enum point_type: { init: 0, helpfuled: 1 }, _prefix: :true
end
