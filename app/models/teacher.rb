class Teacher < ApplicationRecord
  belongs_to :user
  has_many   :lectures, dependent: :destroy
  validates :user_id, presence: true
  validates :name,    presence: true, length: { maximum: 50 }, uniqueness: true

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
