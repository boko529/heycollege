class Zoom < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  # validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  VALID_JOINURL_REGEX = /\A^(http|https):\/\/*(us04web\.)?zoom\.us\/j\/(.*)?$\z/ix
  validates :join_url, presence: true,format: { with: VALID_JOINURL_REGEX }
end
