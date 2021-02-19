class Teacher < ApplicationRecord
  belongs_to :user
  has_many   :lectures
  validates :user_id, presence: true
  validates :name,    presence: true, length: { maximum: 50 }
end
