require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
    @other_user = users(:user4)
    @new_user = User.new(name: "ExampleUser", email: "user@apu.ac.jp",password: "foobar",password_confirmation: "foobar", gender: "male", grade: "B1", faculty: "APS")
    @deleted_user = users(:is_deleted_user)
  end

  test "invalid user should not edit valid user's name" do
    login_as(@other_user, scope: :user)
    get edit_user_path(@user.id)
    assert_redirected_to user_path(@other_user)
  end
  
  test "valid user should edit invalid user's name" do
    login_as(@user, scope: :user)
    get edit_user_path(@user.id)
    patch user_path(@user.id), params: { user: { name:  ""}}
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end
  
  test "valid user should edit valid user information" do
    login_as(@user, scope: :user)
    get edit_user_path(@user.id)
    patch user_path(@user.id), params: { user: { name:  "shouko"}}
    patch user_path(@user.id), params: { user: { gender:  "female"}}
    patch user_path(@user.id), params: { user: { grade:  "M1"}}
    patch user_path(@user.id), params: { user: { faculty:  "APM"}}
    follow_redirect!
    assert_template 'users/show'
    @user.reload
    assert_equal 'shouko', @user.name
    assert_equal 'female', @user.gender
    assert_equal 'M1', @user.grade
    assert_equal 'APM', @user.faculty
    assert_select "div.alert"
  end
  
  test "don't login user should not edit other user information" do
    get edit_user_path(@user.id)
    follow_redirect!
    assert_template 'devise/sessions/new'
    assert_select "div.alert"
  end

  test "others username update" do
    login_as(@user, scope: :user)
    patch user_path(@other_user.id), params: { user: { name:  name } }
    assert_template 'users/edit'
  end
  
  test "others gender faculty gender update" do
    login_as(@user, scope: :user)
    patch user_path(@other_user.id), params: { user: { gender:  "female" } }
    patch user_path(@other_user.id), params: { user: { grade:  "M1" } }
    patch user_path(@other_user.id), params: { user: { faculty: "APM" } }
    follow_redirect!
    assert_template 'users/show'
  end

  test "update not log in" do
    patch user_path(@user.id), params: { user: { name: "taro" } }
    assert_template nil
  end

  test "update gender faculty gender not log in" do
    patch user_path(@other_user.id), params: { user: { gender:  "female" } }
    patch user_path(@other_user.id), params: { user: { grade:  "M1" } }
    patch user_path(@other_user.id), params: { user: { faculty: "APM" } }
    assert_template nil
  end

  test "don't login user don't not watch other user information" do
    get user_path(@user.id)
    follow_redirect!
    assert_template 'devise/sessions/new'
    assert_select "div.alert"
  end

  test "user should not watch user index" do
    @new_user.skip_confirmation!
    login_as(@new_user, scope: :user)
    get admin_users_path
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test "valid is_deleted" do 
    login_as(@user)
    assert @user.active_for_authentication?
    patch users_hide_path(@user)
    assert_not @user.active_for_authentication? #何故かテストがFAILになる
  end

  test "valid show following" do
    login_as(@user)
    get users_following_path(@user)
    assert_template "users/following"
  end

  test "valid show follower" do
    login_as(@user)
    get users_follower_path(@user)
    assert_template "users/follower"
  end

  test "should not show is_deleted user" do
    login_as(@user)
    get user_path(@deleted_user)
    follow_redirect!
    # 退会したユーザーのshowページには行けない
    assert_not flash.empty?
    assert_template root_path
  end

  test "should not following is_deleted user" do
    login_as(@user)
    get users_following_path(@deleted_user)
    follow_redirect!
    # 退会したユーザーのfollowingページには行けない
    assert_not flash.empty?
    assert_template root_path
  end

  test "should not follower is_deleted user" do
    login_as(@user)
    get users_follower_path(@deleted_user)
    follow_redirect!
    # 退会したユーザーのfollowerページには行けない
    assert_not flash.empty?
    assert_template root_path
  end

end
