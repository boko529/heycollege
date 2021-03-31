class News < ApplicationRecord
  belongs_to :university
  validates :title, presence: true, length: { maximum: 30 }
  validates :message, length: { maximum: 300 }
  validates :university_id, presence: true
end
