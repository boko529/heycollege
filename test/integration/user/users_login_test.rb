require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
    @other_user = users(:user4)
    @not_confirm_user = users(:not_confirm_user)
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

  test "valid login information and confirmed user" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    login_as(@user, scope: :user)
    get user_path(@user.id)
    assert_select 'strong', @user.name
    assert @user.confirmed_at.present?
  end

  test "not confirm user don't login" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    login_as(@not_confirm_user, scope: :user)
    assert_template 'devise/sessions/new'
    assert_not @not_confirm_user.confirmed_at.present?
  end
end
