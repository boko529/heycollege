require "test_helper"

class Admin::AutoCreatesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @admin_user = users(:test_admin)
  end

  test "admin user should watch auto_creates new" do
    login_as(@admin_user, scope: :user)
    get new_admin_auto_create_path
    assert_template 'admin/auto_creates/new'
  end
  
  test "user should not watch user index" do
    login_as(@user, scope: :user)
    get new_admin_auto_create_path
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
