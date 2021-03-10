class Zoom < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :description, presence: true
end
