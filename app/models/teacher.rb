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
end
