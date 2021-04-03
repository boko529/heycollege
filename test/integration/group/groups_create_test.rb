require "test_helper"

class GroupsCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:test_admin)
    @user1 = users(:user1)
    @valid_name = "学生自治会" # 「学生自治会」はunique
    @invalid_name = "白鷺祭"   # 「白鷺祭」はuniqueでない.
  end

  test "valid group create" do
    login_as(@user, scope: :user)
    get new_admin_groups_path
    assert_difference 'GroupPointHistory.count', 1 do
      assert_difference 'GroupPoint.count', 1 do
        assert_difference 'UserGroupRelation.count', 1 do
          assert_difference 'Group.count', 1 do
            post admin_groups_path, params: { group: { name: @valid_name, email: @user1.email } }
          end
        end
      end
    end
    follow_redirect!
    assert_template 'groups/show'
    assert_not flash.empty?
    # group作成ユーザーは管理者権限を持つ(adminはtrue)
    group = Group.find_by(name: @valid_name)
    assert_equal UserGroupRelation.find_by(user_id: @user1.id, group_id: group.id).admin, true
  end

  test "invalid group create(not unique)" do
    login_as(@user, scope: :user)
    get new_admin_groups_path
    assert_no_difference 'GroupPoint.count' do
      assert_no_difference 'GroupPointHistory.count' do
        assert_no_difference 'Group.count' do
          post admin_groups_path, params: { group: { name: @invalid_name, email: @user1.email } }
        end
      end
    end
    assert_template root_path
  end

  test "invalid group create(blank name)" do
    login_as(@user, scope: :user)
    get new_admin_groups_path
    assert_no_difference 'GroupPoint.count' do
      assert_no_difference 'GroupPointHistory.count' do
        assert_no_difference 'Group.count' do
          post admin_groups_path, params: { group: { name: "  ", email: @user1.email } }
        end
      end
    end
    assert_template root_path
  end

  test "not admin user cannot create a new group" do
    login_as(@user1, scope: :user)
    get new_admin_groups_path
    assert_no_difference 'GroupPoint.count' do
      assert_no_difference 'GroupPointHistory.count' do
        assert_no_difference 'Group.count' do
          post admin_groups_path, params: { group: { name: @valid_name, email: @user1.email } }
        end
      end
    end
    assert_template nil
  end
end
