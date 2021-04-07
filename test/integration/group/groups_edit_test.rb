require "test_helper"

class GroupsEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) # group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
    @group1 = groups(:group1) # user2が所属
    @group2 = groups(:group2) # user1が所属
    @group3 = groups(:group3) # user1が所属,confirmation == false, user2が所属、leave == true
  end

  test "blank edit" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group1)
    assert_template 'groups/edit'
    patch group_path(@group1), params: { group: { name: "  " }}
    assert_template 'groups/edit'
  end

  test "successful edit" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group1)
    assert_template 'groups/edit'
    name  = "名大祭"
    patch group_path(@group1), params: { group: { name: name } }
    # assert_not flash.empty?
    assert_redirected_to @group1
    @group1.reload
    assert_equal name,  @group1.name
  end

  test "not login edit" do
    get edit_group_path(@group1)
    #CSRF保護の関係らしい
    assert_template nil
    assert_not flash.empty?
  end

  test "admin edit(admin == false)" do
    login_as(@user1, scope: :user)
    get edit_group_path(@group2)
    assert_template nil
  end

  test "admin update(admin == false)" do
    login_as(@user1, scope: :user)
    get edit_group_path(@group2)
    name  = "名大祭"
    patch group_path(@group2), params: { group: { name: name } }
    assert_template nil
    assert_not_equal @group2.name, name
  end

  test "admin user cannot edit other group" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group2)
    assert_template nil
  end

  test "admin user cannot update other group" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group2)
    name  = "名大祭"
    patch group_path(@group2), params: { group: { name: name } }
    assert_template nil
    assert_not_equal @group2.name, name
  end

  test "profile edit" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group1)
    assert_template 'groups/edit'
    profile  = "逃げちゃダメだ、逃げちゃダメだ、逃げちゃダメだ、逃げちゃダメだ、逃げちゃダメだ！"
    patch group_path(@group1), params: { group: { profile: profile } }
    # assert_not flash.empty?
    assert_redirected_to @group1
    @group1.reload
    assert_equal profile,  @group1.profile
  end

  test "non-admin user can not edit profile" do
    login_as(@user1, scope: :user)
    get edit_group_path(@group1)
    follow_redirect!
    assert_template 'groups/show'
    profile  = "怪我したらもう乗らんで済みます！痛いですけど、エヴァに乗るよりはマシですから我慢してください！パァン！"
    patch group_path(@group1), params: { group: { profile: profile } }
    follow_redirect!
    assert_template 'groups/show'
    @group1.reload
    assert_not_equal profile,  @group1.profile
  end

  test "even admin user for a group can not edit other profile" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group2)
    follow_redirect!
    assert_template 'groups/show'
    profile  = "ユイぃ！ユイぃ！ユイぃ！ユイぃ！ユイぃ！どこだぁ！ユイぃ！ユイぃい！！！"
    patch group_path(@group2), params: { group: { profile: profile } }
    follow_redirect!
    assert_template 'groups/show'
    @group1.reload
    assert_not_equal profile,  @group2.profile
  end

  test "not confirmed member can not edit my group" do
    login_as(@user1, scope: :user)
    get edit_group_path(@group3)
    assert_template nil
    name  = "名大祭"
    patch group_path(@group3), params: { group: { name: name } }
    assert_template nil
    assert_not_equal @group3.name, name
  end

  test "a member who already left the group cannot edit it" do
    login_as(@user2, scope: :user)
    get edit_group_path(@group3)
    assert_template nil
    name  = "名大祭"
    patch group_path(@group3), params: { group: { name: name } }
    assert_template nil
    assert_not_equal @group3.name, name
  end
end
