require "test_helper"

class GroupProfilesCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) # group1,group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
    @user4 = users(:user4) # group1,group2に所属、admin == true
    @group1 = groups(:group1)  # user1,user2(admin),user4(admin)が所属,すでにprofile持ってる
    @group2 = groups(:group2)  # user1,user4(admin)が所属,まだprofile持ってない
    @relation2 = user_group_relations(:two) # user2,group1, admin == true
    @relation4 = user_group_relations(:forth) # user1,group1, admin == false
    @profile1 = group_profiles(:profile1) # group1のprofile
  end

  test "valid profile create" do
    login_as(@user4, scope: :user)
    get new_group_profile_path(@group2)
    assert_template 'group_profiles/new'
    assert_difference 'GroupProfile.count', 1 do
      post group_profiles_path(@group2), params: { group_profile: { content: "コンテント" } }
    end
    follow_redirect!
    assert_template 'groups/show'
    assert_not flash.empty?
  end

  test "group should not have more than two profiles" do
    login_as(@user2, scope: :user)
    get new_group_profile_path(@group1)
    assert_template 'group_profiles/new'
    assert_no_difference 'GroupProfile.count' do
      post group_profiles_path(@group1), params: { group_profile: { content: "コンテントaaaaaaa" } }
    end
    follow_redirect!
    assert_template root_path
  end

  test "not login user should not create" do
    get new_group_profile_path(@group1)
    assert_template nil
    assert_no_difference 'GroupProfile.count' do
      post group_profiles_path(@group1), params: { group_profile: { content: "コンテントaaaaaaa" } }
    end
    follow_redirect!
    assert_template root_path
  end

  test "not admin user should not create" do
    login_as(@user1, scope: :user)
    get new_group_profile_path(@group1)
    assert_template nil
    assert_no_difference 'GroupProfile.count' do
      post group_profiles_path(@group1), params: { group_profile: { content: "コンテントaaaaaaa" } }
    end
    follow_redirect!
    assert_template 'groups/show'
  end

  test " user should not create other group's profile " do
    login_as(@user2, scope: :user)
    get new_group_profile_path(@group2)
    assert_template nil
    assert_no_difference 'GroupProfile.count' do
      post group_profiles_path(@group1), params: { group_profile: { content: "コンテントaaaaaaa" } }
    end
    follow_redirect!
    assert_template root_path
  end

end
