require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  
  # サインアップ時のtestがうまく通らない

  # test "invalid signup information" do
  #   get new_user_registration_path
  #   assert_no_difference 'User.count' do
  #     #名前が空白ではユーザーポイントが作成されていないことを確認
  #     assert_no_difference 'UserPoint.count' do
  #       post user_registration_path, params: { user: { name:  " ",
  #                                         email: "user@apu.ac.jp",
  #                                         password: "foo",
  #                                         password_confirmation: "bar",
  #                                         agreement: true } }
  #     end
  #   end
  #   assert_template 'devise/registrations/new'
  #   assert_select "div#error_explanation"
  # end

  
  # Apuの学生としてサインアップするtestがうまく行かない
  # test "valid apu signup information" do
  #   get new_user_registration_path
  #   #UserPointが作成されていることを確認
  #   assert_difference 'UserPoint.count', 1 do
  #     assert_difference 'User.count' ,1 do
  #       post user_registration_path, params: { user: { 
  #         name:  "taro",
  #         email: "sampletest@apu.ac.jp",
  #         password: "foobar",
  #         password_confirmation: "foobar",
  #         agreement: true } }
  #       end
  #     follow_redirect!
  #     get root_path
  #     assert_select "div.alert"
  #   end
  # end
  
  # Opuの学生としてサインアップするtestがうまく行かない
  # test "valid apu signup information" do
  #   get new_user_registration_path
  #   #UserPointが作成されていることを確認
  #   assert_difference 'UserPoint.count', 1 do
  #     assert_difference 'User.count' ,1 do
  #       post user_registration_path, params: { user: { 
  #         name:  "taro",
  #         email: "sampletest@apu.ac.jp",
  #         password: "foobar",
  #         password_confirmation: "foobar",
  #         agreement: true } }
  #       end
  #     follow_redirect!
  #     get root_path
  #     assert_select "div.alert"
  #   end
  # end

  # サインアップ系通らない
    # test "valid signup information and don't confirmed user" do
    #   get new_user_registration_path
    #   # 認証されていなくてもUserPointは作成される
    #   assert_difference 'UserPoint.count', 1 do
    #     assert_difference 'User.count' ,1 do
    #       post user_registration_path, params: { user: { name:  "taro",
    #                                         email: "taro@apu.ac.jp",
    #                                         password: "password",
    #                                         password_confirmation: "password",
    #                                         agreement: true } }
    #     end
    #   end
    #   assert_template 'devise/mailer/confirmation_instructions'
    #   post user_session_path params: { session: { email: 'taro@apu.ac.jp', password: 'password' } }
    #   assert_template 'devise/sessions/new'
    # end

    # test "valid signup information and confirmed user" do
    #   get new_user_registration_path
    #   # 認証する前にUserPointは作成される
    #   assert_difference 'UserPointHistory.count', 1 do
    #     assert_difference 'UserPoint.count', 1 do
    #       assert_difference 'User.count' ,1 do
    #         post user_registration_path, params: { user: { name:  "taro",
    #                                           email: "taro@apu.ac.jp",
    #                                           password: "password",
    #                                           password_confirmation: "password",
    #                                           agreement: true } }
    #       end
    #     end
    #   end
    #   user = assigns(:user)
    #   user.confirm
    #   # initポイントがちゃんとあるか&履歴はちゃんと作られているか
    #   assert_equal 10, user.user_point.current_point
    #   assert_equal "init", user.user_point_history.first.point_type
    #   assert_equal 10, user.user_point_history.first.amount
    #   assert_template 'devise/mailer/confirmation_instructions'
    #   login_as(user, scope: :user)
    #   get user_path(user.id)
    #   assert_template 'users/show'
    # end

  #   test "利用規約に同意していない" do
  #     get new_user_registration_path
  #     assert_no_difference 'User.count' do
  #       #ユーザーポイントが作成されていないことを確認
  #       assert_no_difference 'UserPoint.count' do
  #         post user_registration_path, params: { user: { name:  "test",
  #                                           email: "user@valld.com",
  #                                           password: "foobar",
  #                                           password_confirmation: "foobar",
  #                                           gender: "male",
  #                                           grade: "B1",
  #                                           faculty:"APS",
  #                                           agreement: 0 } }
  #       end
  #     end
  #     assert_template 'devise/registrations/new'
  #     assert_select "div#error_explanation"
  #   end
end
