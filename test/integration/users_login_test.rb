require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
  end

  test "invalid login information" do
    get new_user_session_path
    post user_session_path, params: { session: {
                                        email: @user.email,
                                        password: "invalid" } }
    assert_template 'devise/sessions/new'
    assert_select "div.alert"
  end

  test "valid login information" do
    get new_user_session_path
    post user_session_path, params: { session: { 
                                        email:    @user.email,
                                        password: "password" } }
    assert_template 'devise/sessions/new' 
    assert_select "div.alert"
  end
end
