class Opu::User < User
  enum faculty: { OPU: 1, OPM: 2}, _prefix: :true
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@edu.osakafu-u.ac.jp\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX }
end
