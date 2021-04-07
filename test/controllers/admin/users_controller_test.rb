require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
    @admin_user = users(:test_admin)
  end

  test "admin user should watch user index" do
    login_as(@admin_user, scope: :user)
    get admin_users_path
    assert_template 'admin/users/index'
  end
  
  test "user should not watch user index" do
    login_as(@user, scope: :user)
    get admin_users_path
    # follow_redirect!
    assert_template nil
  end
end
