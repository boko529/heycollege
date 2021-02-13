require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
    @other_user = users(:user4)
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
  
  test "valid user should edit valid user's name" do
    login_as(@user, scope: :user)
    get edit_user_path(@user.id)
    patch user_path(@user.id), params: { user: { name:  "taro"}}
    follow_redirect!
    assert_template 'users/show'
    assert_select "div.alert"
  end
  
  test "don't login user should not edit other user's name" do
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


  test "should get show" do
    get user_path(@user.id)
    assert_response :success
  end
end
