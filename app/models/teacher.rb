class Teacher < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name,    presence: true, length: { maximum: 50 }
end
