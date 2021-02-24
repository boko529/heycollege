require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  test "invalid signup information" do
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
      post user_registration_path, params: { user: { 
        name:  "taro",
        email: "taro@example.com",
        password: "password",
        password_confirmation: "password",
        gender: "male",
        grade: "B1",
        faculty:"APS" } }
      end
      get root_path
      assert_select "div.alert"
    end

    test "valid signup information and don't confirmed user" do
      get new_user_registration_path
      assert_difference 'User.count' ,1 do
        post user_registration_path, params: { user: { name:  "taro",
                                          email: "taro@example.com",
                                          password: "password",
                                          password_confirmation: "password",
                                          gender: "male",
                                          grade: "B1",
                                          faculty:"APS" } }
      end
      assert_template 'devise/mailer/confirmation_instructions'
      post user_session_path params: { session: { email: 'taro@example.com', password: 'password' } }
      assert_template 'devise/sessions/new'
    end

    test "valid signup information and confirmed user" do
      get new_user_registration_path
      assert_difference 'User.count' ,1 do
        post user_registration_path, params: { user: { name:  "taro",
                                          email: "taro@example.com",
                                          password: "password",
                                          password_confirmation: "password",
                                          gender: "male",
                                          grade: "B1",
                                          faculty:"APS" } }
      end
      user = assigns(:user)
      user.confirm
      assert_template 'devise/mailer/confirmation_instructions'
      post user_session_path params: { session: { email: 'taro@example.com', password: 'password' } }
      get user_path(user.id)
      assert_template 'users/show'
    end
end
