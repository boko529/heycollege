class University < ApplicationRecord
  has_many :users
  has_many :groups
  has_many :lectures
  has_many :news
  has_many :teachers
  validates :name_ja, presence: true
end
