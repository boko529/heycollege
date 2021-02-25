class Lecture < ApplicationRecord
  belongs_to :user
  belongs_to :teacher
  has_many :reviews, dependent: :destroy
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: {scope: :teacher_id}
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
  
  #詳細が省略されているものも含む。レビュー数表示用
  def all_reviews_count
    return self.reviews.count
  end

  # ユーザーがその投稿にレビューをしているかの確認
  def review?(user)
    user.reviews.where(lecture_id: self.id).exists?
  end

  # ユーザーがその投稿にしたレビューを返す
  def my_review(user)
    if self.review?(user)
      return user.reviews.where(lecture_id: self.id).first
    end
  end
end
