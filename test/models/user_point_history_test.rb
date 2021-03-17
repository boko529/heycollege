require "test_helper"

class UserPointHistoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:user3)
    @user_point = @user.create_user_point(current_point: 10, total_point: 10)
    @point_history = @user.user_point_history.build(point_type: 1, amount: 10, user_point_id: @user_point.id)
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

  test "user_id should be present" do
    @point_history.user_id = nil
    assert_not @point_history.valid?
  end

  test "user_point_id should be present" do
    @point_history.user_point_id = nil
    assert_not @point_history.valid?
  end
end
