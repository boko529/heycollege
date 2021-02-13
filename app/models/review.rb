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

  def average_score
    average_score = ( self.explanation + self.fairness + self.recommendation + self.useful + self.interesting ) / 5
    return average_score.round(2)
  end
  
end
