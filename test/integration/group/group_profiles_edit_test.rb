require "test_helper"

class GroupProfilesEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) # group1, group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
  #  @user4 = users(:user4) # group1,group2に所属、admin == true
    @group1 = groups(:group1)  # user1,user2(admin),user4(admin)が所属,すでにprofile持ってる
    @group2 = groups(:group2)  # user1,user4(admin)が所属,まだprofile持ってない
    @relation2 = user_group_relations(:two) # user2,group1, admin == true
    @relation4 = user_group_relations(:forth) # user1,group1, admin == false
    @profile1 = group_profiles(:profile1) # group1のprofile
    @profile3 = group_profiles(:profile3) # group3のprofile
  end

  test "valid profile edit" do
    login_as(@user2, scope: :user)
    get edit_group_profile_path(@profile1)
    assert_template 'group_profiles/edit'
    content = "ああああああああ"
    patch group_profile_path(@profile1), params: { group_profile: { content: content } }
    follow_redirect!
    assert_template 'groups/show'
    assert_not flash.empty?
    @profile1.reload
    assert_equal content, @profile1.content
  end

  test "not login user should not create" do
    get edit_group_profile_path(@profile1)
    assert_template nil
    content = "ああああああああ"
    patch group_profile_path(@profile1), params: { group_profile: { content: content } }
    follow_redirect!
    assert_template root_path
    @profile1.reload
    assert_not_equal content, @profile1.content
  end

  test "not admin user should not edit" do
    login_as(@user1, scope: :user)
    get edit_group_profile_path(@profile1)
    assert_template nil
    content = "ああああああああ"
    patch group_profile_path(@profile1), params: { group_profile: { content: content } }
    follow_redirect!
    assert_template 'groups/show'
    @profile1.reload
    assert_not_equal content, @profile1.content
  end

  test " user should not edit other group's profile " do
    login_as(@user2, scope: :user)
    get edit_group_profile_path(@profile3)
    assert_template nil
    content = "ああああああああ"
    patch group_profile_path(@profile3), params: { group_profile: { content: content } }
    follow_redirect!
    assert_template 'groups/show'
    @profile1.reload
    assert_not_equal content, @profile3.content
  end

  test "valid profile destroy" do
    login_as(@user2, scope: :user)
    assert_difference 'GroupProfile.count', -1 do
      delete group_profile_path(@profile1)
    end
    follow_redirect!
    assert_template 'groups/show'
    assert_not flash.empty?
  end 

  test "not admin user should not destroy profile" do
    login_as(@user1, scope: :user)
    assert_no_difference 'GroupProfile.count' do
      delete group_profile_path(@profile1)
    end
    follow_redirect!
    assert_template 'groups/show'
  end

  test "not login user should not destroy profile" do
    assert_no_difference 'GroupProfile.count' do
      delete group_profile_path(@profile1)
    end
    follow_redirect!
    assert_template root_path
  end

  test "user should not destroy other group's profile" do
    login_as(@user2, scope: :user)
    assert_no_difference 'GroupProfile.count' do
      delete group_profile_path(@profile3)
    end
    follow_redirect!
    assert_template 'groups/show'
  end

end
