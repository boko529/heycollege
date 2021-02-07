class Lecture < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
end
