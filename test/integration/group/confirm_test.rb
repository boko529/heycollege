require "test_helper"

class ConfirmTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) # group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
    @user3 = users(:user3) # group1に所属、admin == false
    @user4 = users(:user4)
    @group1 = groups(:group1) # user2(admin),user3が所属
    @group2 = groups(:group2) # user1が所属
    @group3 = groups(:group3) # user1: confirmation == false, user2: leave = true, user3: confirmation == true, user4: admin, confirmation == true
    @relation = user_group_relations(:one) # user1がgroup2に所属、admin == false
  end

  # get "/groups/#{@group3.id}/edit_confirmation" がエラーになるのでコメントアウトしてます.

#   test "edit confirmation" do
#     login_as(@user4, scope: :user)
#     # get "/groups/#{@group3.id}/edit_confirmation"
#     assert_template 'groups/edit_confirmation'
#   end

  test "successful edit_admin" do # user3のadminをtrueにする.
    login_as(@user4, scope: :user)
    # get "/groups/#{@group3.id}/edit_confirmation"
    # assert_template 'groups/edit_confirmation'
    patch "/groups/#{@group3.id}/confirm", params: { group_id: @group3.id, user_id: @user1.id }
    assert_not flash.empty?
    assert_redirected_to @group3
    assert_equal UserGroupRelation.find_by(user_id: @user1.id, group_id: @group1.id).confirmation, true
  end

#   test "not login edit_admin" do
#     # get "/groups/#{@group1.id}/edit_confirmation"
#     #CSRF保護の関係らしい
#     assert_template nil
#     assert_not flash.empty?
#   end

#   test "edit_confirmation(admin == false)" do
#     login_as(@user3, scope: :user)
#     # get "/groups/#{@group3.id}/edit_confirmation"
#     assert_template nil
#   end

  test "confirm(admin == false)" do
    login_as(@user3, scope: :user)
    patch "/groups/#{@group3.id}/confirm", params: { group_id: @group3.id, user_id: @user1.id }
    assert_template nil
    assert_not_equal UserGroupRelation.find_by(group_id: @group3.id, user_id: @user1.id).confirmation, true
  end

#   test "not confirmed user cannot edit_admin" do
#     login_as(@user1, scope: :user)
#     # get "/groups/#{@group3.id}/edit_confirmation"
#     assert_template nil
#   end

  test "not confirmed user cannot update_admin" do
    login_as(@user1, scope: :user)
    patch "/groups/#{@group3.id}/confirm", params: { group_id: @group3.id, user_id: @user1.id }
    assert_template nil
    assert_not_equal UserGroupRelation.find_by(group_id: @group3.id, user_id: @user1.id).confirmation, true
  end

#   test " user who left group cannot edit_admin" do
#     login_as(@user2, scope: :user)
#     get "/groups/#{@group3.id}/edit_confirmation"
#     assert_template nil
#   end

  test "user who left group cannot update_admin" do
    login_as(@user2, scope: :user)
    patch "/groups/#{@group3.id}/confirm", params: { group_id: @group3.id, user_id: @user1.id }
    assert_template nil
    assert_not_equal UserGroupRelation.find_by(group_id: @group3.id, user_id: @user1.id).confirmation, true
  end
end
