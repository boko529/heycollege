class Review < ApplicationRecord
  belongs_to :user
  belongs_to :lecture
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :explanation, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :fairness, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :recommendation, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :useful, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  validates :interesting, presence: true, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }
  
end
