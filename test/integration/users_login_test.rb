require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
  end

  test "invalid login information" do
    get new_user_session_path
    assert_no_difference 'User.count' do
      post user_session_path, params: { user: {
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "invalid" } }
    end
    assert_template 'devise/sessions/new'
    assert_select "div.alert"
  end
end
