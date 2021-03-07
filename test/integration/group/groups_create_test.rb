require "test_helper"

class GroupsCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @valid_name = "学生自治会" # 「学生自治会」はunique
    @invalid_name = "白鷺祭"   # 「白鷺祭」はuniqueでない.
  end

  test "valid group create" do
    login_as(@user, scope: :user)
    get new_group_path
    assert_difference 'UserGroupRelation.count', 1 do
      assert_difference 'Group.count', 1 do
        post groups_path, params: { group: { name: @valid_name } }
      end
    end
    follow_redirect!
    assert_template 'groups/show'
    assert_not flash.empty?
    # group作成ユーザーは管理者権限を持つ(adminはtrue)
    group = Group.find_by(name: @valid_name)
    assert_equal UserGroupRelation.find_by(user_id: @user.id, group_id: group.id).admin, true
  end

  test "invalid group create(not unique)" do
    login_as(@user, scope: :user)
    get new_group_path
    assert_no_difference 'Group.count' do
      post groups_path, params: { group: { name: @invalid_name } }
    end
    assert_template 'groups/new'
  end

  test "invalid group create(blank name)" do
    login_as(@user, scope: :user)
    get new_group_path
    assert_no_difference 'Group.count' do
      post groups_path, params: { group: { name: "  " } }
    end
    assert_template 'groups/new'
  end


end
