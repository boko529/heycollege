class Apu::User < User
  enum faculty: { APS: 1, APM: 2}, _prefix: :true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@apu.ac.jp\z/i
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX }
end
