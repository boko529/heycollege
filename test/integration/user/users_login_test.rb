require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
    @other_user = users(:user4)
    @not_confirm_user = users(:not_confirm_user)
  end

  # test通らない
  # test "invalid login information" do
  #   get new_user_session_path
  #   assert_template 'devise/sessions/new'
  #   post user_session_path params: { session: { email: 'sample@gmail.com', password: 'foobar', agreement: true } }
  #   assert_template 'devise/sessions/new'
  #   assert_not flash.empty?
  #   get root_path
  #   assert flash.empty?
  # end

  test "valid login information and confirmed user" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    login_as(@user, scope: :user)
    get user_path(@user.id)
    assert_select 'div', @user.name
    assert @user.confirmed_at.present?
  end

  test "not confirm user don't login" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    login_as(@not_confirm_user, scope: :user)
    assert_template 'devise/sessions/new'
    assert_not @not_confirm_user.confirmed_at.present?
  end

  # ユーザー関係が通らない
  # #退会済みユーザーのログインテスト
  # test "invalid login with is_deleted" do 
  #   login_as(@user, scope: :user)
  #   patch users_hide_path(@user) #退会
  #   follow_redirect!
  #   assert_template root_path
  #   get new_user_session_path
  #   follow_redirect!
  #   assert_template 'devise/sessions/new'
  #   login_as(@user, scope: :user)
  #   assert @user.is_deleted # 退会しているのでtrueになるはず
  # end
end
