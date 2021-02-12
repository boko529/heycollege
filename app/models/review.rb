class Review < ApplicationRecord
  belongs_to :user
  belongs_to :lecture
  validates :title, presence: true, length: { maximum: 20 }
  validates :content, presence: true, length: { maximum: 300 }
  
end
