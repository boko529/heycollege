class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :lecture
  validates :user_id, uniqueness: { scope: :lecture_id }
end
