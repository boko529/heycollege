class Zoom < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  # validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  VALID_JOINURL_REGEX = /\A^(http|https):\/\/*(us04web\.)?zoom\.us\/j\/(.*)?$\z/ix
  validates :join_url, presence: true,format: { with: VALID_JOINURL_REGEX }
  validate :start_end_check
  validate :start_check
  has_many :users, through: :user_zooms
  has_many :user_zooms

  def start_end_check
    errors.add(:end_time, "は開始時刻より遅い時間を選択してください") if self.start_time > self.end_time
  end

  def start_check
    errors.add(:start_time, "は現在の日時より遅い時間を選択してください") if self.start_time < Time.now
  end
end
