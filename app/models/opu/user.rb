class Opu::User < User
  enum faculty: { Gensisu: 1, Kougaku: 2, Seikan: 3, Tiiki: 4 }, _prefix: :true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@.+\.osakafu-u.ac.jp\z/i # サブドメインは自由に変更
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@edu.osakafu-u.ac.jp\z/i
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX }
end
