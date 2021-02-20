class News < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :message, length: { maximum: 300 }
end
