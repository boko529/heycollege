class UserZoom < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :zoom, class_name: "Zoom"
  validates :user_id, presence: true
  validates :zoom_id, presence: true
end
