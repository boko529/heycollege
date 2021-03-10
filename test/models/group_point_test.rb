require "test_helper"

class GroupPointTest < ActiveSupport::TestCase
  def setup
    @group = groups(:group1)
    @group_point = @group.build_group_point(current_point: 10, total_point: 10)
  end

  test "should be valid" do
    assert @group_point.valid?
  end

  test "group id should be present" do
    @group_point.group_id = nil
    assert_not @group_point.valid?
  end
  
  test "current_point should be present" do
    @group_point.current_point = nil
    assert_not @group_point.valid?
  end

  test "total_point should be present" do
    @group_point.total_point = nil
    assert_not @group_point.valid?
  end
end
