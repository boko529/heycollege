require "test_helper"

class UserGroupRelationTest < ActiveSupport::TestCase
  def setup
    @relation = UserGroupRelation.new(user_id: users(:user1).id,
                                      group_id: groups(:group1).id)
  end

  test "should be valid" do
    assert @relation.valid?
  end

  test "should require a user_id" do
    @relation.user_id = nil
    assert_not @relation.valid?
  end

  test "should require a group_id" do
    @relation.group_id = nil
    assert_not @relation.valid?
  end

  test "should follow and unfollow a user" do
    user = users(:user1)
    group = groups(:group1)
    assert_not user.belongs?(group)
    user.join(group)
    assert user.belongs?(group)
    user.unjoin(group)
    assert_not user.belongs?(group)
  end
end
