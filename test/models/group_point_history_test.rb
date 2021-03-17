require "test_helper"

class GroupPointHistoryTest < ActiveSupport::TestCase
  def setup
    @group = groups(:group1)
    @group_point = @group.create_group_point(current_point: 10, total_point: 10)
    @point_history = @group.group_point_history.build(point_type: 0, amount: 10, group_point_id: @group_point.id)
  end

  test "should be valid" do
    assert @point_history.valid?
  end

  test "point type should be present" do
    @point_history.point_type = nil
    assert_not @point_history.valid?
  end

  test "amount should be present" do
    @point_history.amount = nil
    assert_not @point_history.valid?
  end

  test "group_id should be present" do
    @point_history.group_id = nil
    assert_not @point_history.valid?
  end

  test "group_point_id should be present" do
    @point_history.group_point_id = nil
    assert_not @point_history.valid?
  end
end
