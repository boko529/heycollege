class GroupPoint < ApplicationRecord
  belongs_to :group
  has_many :group_point_history, dependent: :destroy
  validates :group_id, presence: true
  validates :current_point, presence: true
  validates :total_point, presence: true
end
