class Lecture < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :language_used, presence: true
  validates :lecture_type, presence: true
  validates :lecture_term, presence: true
  validates :lecture_size, presence: true
  validates :group_work, presence: true
  validates :user_id, presence: true

  enum language_used:{
    Japanese:        0, #日本語
    English:         1, #英語
    others:          2, #その他
  }

  enum lecture_type:{
    APM:             0, #APM
    APS:             1, #APS
    Liberal_arts:    2, #一般教養
    Language:        3, #言語
    Seminar:         4, #ゼミ
  }

  enum lecture_term:{
    spring:          0, #春セミスター
    summer:          1, #夏セッション
    autumn:          2, #秋セミスター
    winter:          3, #冬セッション
  }
 
  enum lecture_size:{
    small:           0, #20人以下
    medium:          1, #20人～70人
    large:           2, #70人～100人
    extra_large:     3, #100人以上
  }

  enum group_work:{
    included:        0, #あり
    not_included:    1, #なし
  }

  # self.は省略できるけどこっちの方が可読性高い気がするから残しときます
  def average_score
    if self.reviews.blank?
      return "不明"
    else
      sum = 0
      self.reviews.each do |review|
        sum = sum + review.average_score
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
end
