class GroupProfile < ApplicationRecord
  belongs_to :group
  validates :content, length: { maximum: 1000 }, presence: true
end
