class Lecture < ApplicationRecord
  belongs_to :user
  belongs_to :teacher
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  # name_jaかname_enのどちらかは必須(両方あってもいいよ)
  validates :name_ja, presence: true, length: { maximum: 50 }, uniqueness: {scope: :teacher_id}, unless: :name_en?
  validates :name_en, presence: true, length: { maximum: 50 }, uniqueness: {scope: :teacher_id}, unless: :name_ja?
  validates :user_id, presence: true
  validates :teacher_id, presence: true
  validates :field, presence: true
  validates :lecture_lang: true
  attr_accessor :score
  enum lecture_lang: { ja: 1, en: 2, es: 3, ko: 4, zh: 5, ms: 6, th: 7, vi: 8, ej: 9}, _prefix: :true # es=>スペイン語, ko=>韓国語, zh=>中国語, ms=>マレーシア語＋インドネシア語, th=>タイ語, vi=>ベトナム語, ej=>日本語英語兼用
  enum field: { APS: 1, APM: 2, APSAPM: 3, Liberal: 4, Language: 5}, _prefix: :true

  # self.は省略できるけどこっちの方が可読性高い気がするから残しときます
  def average_score
    if self.reviews.blank?
      return "不明"
    else
      sum = 0
      self.reviews.includes(:lecture).each do |review|
        sum = sum + review.score
      end
      average_score = sum / self.reviews.count
      return average_score.round(2)
    end
  end

  # #editのときはフォームに初期値をnewのときは空白にする 
  # def init_first_name
  #   if self.teacher.present?
  #     return self.teacher.name.split(" ")[1]
  #   end
  # end

  # def init_last_name
  #   if self.teacher.present?
  #     return self.teacher.name.split(" ")[0]
  #   end
  # end
  
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

  # ブックマーク機能
  def bookmarked_by?(user)
    bookmarks.where(user_id: user).exists?
  end
  
  #最も参考になるが多いレビューを返す。
  def most_helpful_review
    self.reviews.where.not(content: "").includes(:helpfuls).sort{ |a,b| b.helpfuls.size <=> a.helpfuls.size }.first
  end
end
