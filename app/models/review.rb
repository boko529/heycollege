class Review < ApplicationRecord
  belongs_to :user
  belongs_to :lecture
  has_many :helpfuls
  has_many :notifications, dependent: :destroy
  validates :content, length: { maximum: 1000 }
  validates :score, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }

  def helpfuled_by?(user)
    helpfuls.where(user_id: user.id).exists?
  end
  
end
