class Teacher < ApplicationRecord
  belongs_to :user
  has_many   :lectures, dependent: :destroy
  validates :user_id, presence: true
  validates :name,    presence: true, length: { maximum: 50 }, uniqueness: true

  def average_score
    if self.lectures.blank?
      return "不明"
    else
      sum = 0
      count = 0  # lecture.average_scoreが"不明"のものはcountしたくないのでself.lectures.countは使用しない.
      self.lectures.each do |lecture|
        if lecture.average_score == "不明"
          0
        else
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

end
