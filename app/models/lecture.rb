class Lecture < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :user_id, presence: true
  attr_accessor :score

  # self.は省略できるけどこっちの方が可読性高い気がするから残しときます
  def average_score
    if self.reviews.blank?
      return "不明"
    else
      sum = 0
      self.reviews.each do |review|
        sum = sum + review.score
      end
      average_score = sum / self.reviews.count
      return average_score.round(2)
    end
  end
  
  # ここからカラムを引数にしてアベレージを返すってきれいにできるのかも
  def average_explanation
    if self.reviews.blank?
      return "不明"
    else
      return self.reviews.average(:explanation).round(2)
    end
  end

  def average_fairness
    if self.reviews.blank?
      return "不明"
    else
      return self.reviews.average(:fairness).round(2)
    end
  end

  def average_recommendation
    if self.reviews.blank?
      return "不明"
    else
      return self.reviews.average(:recommendation).round(2)
    end
  end

  def average_useful
    if self.reviews.blank?
      return "不明"
    else
      return self.reviews.average(:useful).round(2)
    end
  end

  def average_interesting
    if self.reviews.blank?
      return "不明"
    else
      return self.reviews.average(:interesting).round(2)
    end
  end

  def average_difficulty
    if self.reviews.blank?
      return "不明"
    else
      return self.reviews.average(:difficulty).round(2)
    end
  end
end
