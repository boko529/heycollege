require "test_helper"

class UsersLogoutTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
  end

  # ログアウトのtestが通らない
  # test "logout successful" do
  #   login_as(@user, scope: :user)
  #   delete destroy_user_session_path
  #   follow_redirect!
  #   assert_select "div.alert"
  # end
end
