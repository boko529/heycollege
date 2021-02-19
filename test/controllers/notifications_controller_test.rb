require "test_helper"
class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @lecture = lectures(:lecture_1)
    @review = reviews(:review1)
  end

  test "notification index" do
    login_as(@user1, scope: :user)
    get notifications_path
    assert_template "notifications/index"
  end

  #ログインしてないと弾かれる
  test "notification index not login" do
    get notifications_path
    assert_template nil
  end
end
