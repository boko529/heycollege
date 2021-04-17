class Zoom < ApplicationRecord
  belongs_to :user
  belongs_to :university
  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  # ZOOM招待URLのバリデーション
  # VALID_JOINURL_REGEX = /\A^(http|https):\/\/*(us04web\.)?zoom\.us\/j\/(.*)?$\z/ix
  # VALID_JOINURL_REGEX = /\A^(http|https):\/\/*(us)?[0-9]?[0-9]?(web\.)?zoom\.us\/j\/(.*)?$\z/ix
  VALID_JOINURL_REGEX = /\A^(http|https):\/\/.*?zoom\.us\/j\/(.*)?$\z/ix
  validates :join_url, presence: true,format: { with: VALID_JOINURL_REGEX }
  validate :start_end_check
  validate :start_check
  validates :university_id, presence: true
  has_many :users, through: :user_zooms
  has_many :user_zooms

  def start_end_check
    errors.add(:end_time, "は開始時刻より遅い時間を選択してください") if self.start_time.present? && end_time.present? && self.start_time > self.end_time
  end

  def start_check
    errors.add(:start_time, "は現在の日時より遅い時間を選択してください") if self.start_time.present? && start_time < Time.now - 600
    #zoom作成時の時刻に余裕を持たせる
  end
end
