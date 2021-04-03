require "test_helper"

class GroupsEditAdminTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) # group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
    @user3 = users(:user3) # group1に所属、admin == false
    @group1 = groups(:group1) # user2(admin),user3が所属
    @group2 = groups(:group2) # user1が所属
    @group3 = groups(:group3) # user1: confirmation == false, user2: leave = true
    @relation = user_group_relations(:one) # user1がgroup2に所属、admin == false
  end

  test "edit admin" do
    login_as(@user2, scope: :user)
    get "/groups/#{@group1.id}/edit_admin"
    assert_template 'groups/edit_admin'
  end

  test "successful edit_admin" do # user3のadminをtrueにする.
    login_as(@user2, scope: :user)
    get "/groups/#{@group1.id}/edit_admin"
    assert_template 'groups/edit_admin'
    patch "/groups/#{@group1.id}/update_admin", params: { id: @group1.id, user_id: @user3.id }
    assert_not flash.empty?
    assert_redirected_to @group1
    assert_equal UserGroupRelation.find_by(user_id: @user3.id, group_id: @group1.id).admin, true
  end

  test "not login edit_admin" do
    get "/groups/#{@group1.id}/edit_admin"
    #CSRF保護の関係らしい
    assert_template nil
    assert_not flash.empty?
  end

  test "edit_admin(admin == false)" do
    login_as(@user1, scope: :user)
    get "/groups/#{@group2.id}/edit_admin"
    assert_template nil
  end

  test "update_admin(admin == false)" do
    login_as(@user1, scope: :user)
    patch "/groups/#{@group2.id}/update_admin", params: { id: @group2.id, user_id: @user1.id }
    assert_template nil
    assert_not_equal @relation.admin, true
  end

  test "admin user cannot edit other group admin" do
    login_as(@user2, scope: :user)
    get "/groups/#{@group2.id}/edit_admin"
    assert_template nil
  end

  test "admin user cannot update other group admin" do
    login_as(@user2, scope: :user)
    patch "/groups/#{@group2.id}/update_admin", params: { id: @group2.id, user_id: @user2.id }
    assert_template nil
    assert_not_equal @relation.admin, true
  end

  test "not confirmed user cannot edit_admin" do
    login_as(@user1, scope: :user)
    get "/groups/#{@group3.id}/edit_admin"
    assert_template nil
  end

  test "not confirmed user cannot update_admin" do
    login_as(@user1, scope: :user)
    patch "/groups/#{@group3.id}/update_admin", params: { id: @group3.id, user_id: @user3.id }
    assert_template nil
    assert_not_equal @relation.admin, true
  end

  test " user who left group cannot edit_admin" do
    login_as(@user2, scope: :user)
    get "/groups/#{@group3.id}/edit_admin"
    assert_template nil
  end

  test "user who left group cannot update_admin" do
    login_as(@user2, scope: :user)
    patch "/groups/#{@group3.id}/update_admin", params: { id: @group3.id, user_id: @user3.id }
    assert_template nil
    assert_not_equal @relation.admin, true
  end
end
