require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @user3 = users(:user3)
  end

  test "invalid signup information" do
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post user_registration_path, params: { user: { name:  "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar" } }
    end
    assert_template 'devise/registrations/new'
    assert_select "div#error_explanation"
  end

  test "valid signup information" do
    get new_user_registration_path
    assert_difference 'User.count' do
      post user_registration_path, params: { user: { name:  "taro",
                                        email: "taro@example.com",
                                        password:              "password",
                                        password_confirmation: "password" } }
    end
    get root_path
    assert_template 'static_pages/home' 
    assert_select "div.alert"
  end
end
