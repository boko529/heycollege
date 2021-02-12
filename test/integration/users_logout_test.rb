require "test_helper"

class UsersLogoutTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
  end

  test "logout successful" do
    login_as(@user, scope: :user)
    assert_no_difference 'User.count' do
      delete destroy_user_session_path
    end
    get root_path
    assert_template 'static_pages/home' 
    assert_select "div.alert"
  end
end
