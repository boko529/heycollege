require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
    @other_user = users(:user4)
  end

  test "invalid login information" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    post user_session_path params: { session: { email: '', password: '' } }
    assert_template 'devise/sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "valid login information" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    login_as(@other_user, scope: :user)
    get user_path(@user.id)
    assert_select 'td', @user.name
  end
end
