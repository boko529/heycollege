require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @new_user = User.new(name: "ExampleUser", email: "user@example.com",password: "foobar",password_confirmation: "foobar", gender: "male", grade: "B1", faculty: "APS")
  end

  test "invalid signup information password" do
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post user_registration_path, params: { user: { name:  "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar",
                                        gender: "male",
                                        grade: "B1",
                                        faculty:"APS" } }
    end
    assert_template 'devise/registrations/new'
    assert_select "div#error_explanation"
  end

  test "valid signup information" do
    get new_user_registration_path
    assert_difference 'User.count' ,1 do
      post user_registration_path, params: { user: { name:  "taro",
                                        email: "taro@example.com",
                                        password: "password",
                                        password_confirmation: "password",
                                        confirmed_at: Time.now - 100,
                                        gender: "male",
                                        grade: "B1",
                                        faculty:"APS" } }
    end
    get root_path
    assert_template 'static_pages/home' 
    assert_select "div.alert"
  end
  
  test "valid signup information2" do
    @new_user = User.new(name: "ExampleUser", email: "user@example.com",password: "foobar",password_confirmation: "foobar", gender: "male", grade: "B1", faculty: "APS")
    @new_user.skip_confirmation!
    @new_user.save
    get user_path(@new_user.id)
    assert_template 'users/show' 
    assert_select 'td', @new_user.name
  end
end
