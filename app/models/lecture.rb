class Lecture < ApplicationRecord
  belongs_to :user
  belongs_to :teacher
  has_many :reviews, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  belongs_to :university
  # name_jaかname_enのどちらかは必須(両方あってもいいよ),文字数は50字まで。分けて書かない方法もあるだろうけど。。
  validates :name_ja, presence: true, unless: :name_en?
  validates :name_ja, length: { maximum: 70 }, uniqueness: {scope: :teacher_id} # 大学内は含まれてるのでscopeつけてない
  validates :name_en, presence: true, unless: :name_ja?
  validates :name_en, length: { maximum: 70 }, uniqueness: {scope: :teacher_id} # 大学内は含まれているのでscopeつけていない
  validates :user_id, presence: true
  validates :teacher_id, presence: true
  validates :field, presence: true
  validates :lecture_lang, presence: true
  validates :university_id, presence: true
  # validates :lecture_term, presence: true
  # validates :day_of_week, presence: true
  # validates :period, presence: true
  attr_accessor :score
  # enum lecture_lang: { none: 0, ja: 1, en: 2, es: 3, ko: 4, zh: 5, ms: 6, th: 7, vi: 8, ej: 9, fr: 10, de: 11}, _prefix: :true # es=>スペイン語, ko=>韓国語, zh=>中国語, ms=>マレーシア語＋インドネシア語, th=>タイ語, vi=>ベトナム語, ej=>日本語英語兼用, fr => フランス語, de => ドイツ語
  # enum lecture_term: { First: 1, Second: 2, Q1: 3, Q2: 4, Q3: 5, Q4: 6, session1: 7, session2: 8}, _prefix: :true # 1,2は2期制,3,4,5,6は4期生, 7は夏セッション(集中講義), 8は冬セッション(集中講義)
  # enum day_of_week: { Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7, Other: 8}, _prefix: :true
  # enum period: { none: 0, first: 1, second: 2, third: 3, fourth: 4, fifth: 5, sixth: 6 }, _prefix: :true # ないときに"--"を入れたいのでenumにした

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
