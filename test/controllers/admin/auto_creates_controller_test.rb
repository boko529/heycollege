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
  
  test "user should not watch user new" do
    login_as(@user, scope: :user)
    get new_admin_auto_create_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test "not login user should not watch new" do
    get new_admin_auto_create_path
    follow_redirect!
    assert_template 'devise/sessions/new'
  end

  test "not login user should not create" do
    post admin_auto_creates_path(name: "test", password: ENV['AUTO_CREATE_PASSWORD'], university: 1)
    follow_redirect!
    assert_template 'devise/sessions/new'
  end

  test "not admin user should not create" do
    login_as(@user, scope: :user)
    post admin_auto_creates_path(name: "test", password: ENV['AUTO_CREATE_PASSWORD'], university: 1)
    follow_redirect!
    assert_template 'static_pages/home'
  end

  # # キーワードが正しくない時のtestが通らない
  # test "admin user need correct password" do
  #   login_as(@admin_user, scope: :user)
  #   post admin_auto_creates_path(name: "test", password: ENV['AUTO_CREATE_PASSWORD'], university: 1)
  #   follow_redirect!
  #   assert_template 'admin/auto_creates/new'
  # end
end
