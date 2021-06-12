class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_mail.subject
  #
  def send_mail(user)
    @user = user
    # ここでメールのタイトルを変更します。
    mail to: user.email, subject: "Sample from HeyCollege"
  end

  def test_mail(user)
    @user = user
    # test送信用のメアド
    # mail to: "sdb03111@edu.osakafu-u.ac.jp", subject: "HeyCollege | メールテスト"
    mail to: "mccshahaha@gmail.com", subject: "HeyCollege | メールテスト"
  end
end
