require "test_helper"

class GroupsEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) # group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
    @group1 = groups(:group1) # user2が所属
    @group2 = groups(:group2) # user1が所属
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
    assert_not flash.empty?
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
end
