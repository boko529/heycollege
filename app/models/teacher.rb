class Teacher < ApplicationRecord
  belongs_to :user
  has_many   :lectures, dependent: :destroy
  validates :user_id, presence: true
  validates :name,    presence: true, length: { maximum: 50 }, uniqueness: true

  def average_score
    if self.lectures.blank?
      return 0 # 数字を返り値にしたいので「不明」から0に変更しました.
    else
      sum = 0
      count = 0  # lecture.average_scoreが"不明"のものはcountしたくないのでself.lectures.countは使用しない.
      self.lectures.includes(:reviews).each do |lecture|
        unless lecture.average_score == "不明"
          sum += lecture.average_score
          count += 1
        end
      end
      if count == 0
        average_score = 0
      else
        average_score = sum / count
      end
      return average_score.round(1)
    end
  end

  #editのときはフォームに初期値をnewのときは空白にする 
  def init_first_name
    if self.name.present?
      return self.name.split(" ")[1]
    end
  end

  def init_last_name
    if self.name.present?
      return self.name.split(" ")[0]
    end
  end

  # 先生に関係するレビューを参考になっている順で獲得(内容があるもの限定、空白表示してもしょうがないかなと思って)
  def teacher_reviews
    all_reviews = []
    self.lectures.includes(:reviews).each do |lecture|
      all_reviews.push(lecture.reviews.where.not(content: "").includes(:helpfuls))
    end
    all_reviews = all_reviews.flatten!  #これで配列の中に複数の配列が入っている状態を展開して一つの配列にしている。いきなり配列うまく行かなかった。
    unless all_reviews.blank?
      return all_reviews.sort{ |a,b| b.helpfuls.size <=> a.helpfuls.size }
    end
  end

  #先生に関するレビュー数(星のみを含む)をかえす(helpfulはincludeしない)
  def review_comment_count
    all_reviews = []
    self.lectures.includes(:reviews).each do |lecture|
      all_reviews.push(lecture.reviews)
    end
    all_reviews = all_reviews.flatten!
    unless all_reviews.blank?
      return all_reviews.count
    else
      return 0
    end
  end
end
