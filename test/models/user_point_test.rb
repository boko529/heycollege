require "test_helper"

class UserPointTest < ActiveSupport::TestCase
  def setup
    @user = users(:user3)
    @user_point = @user.build_user_point(current_point: 10, total_point: 10)
  end

  test "should be valid" do
    assert @user_point.valid?
  end

  test "user id should be present" do
    @user_point.user_id = nil
    assert_not @user_point.valid?
  end
  
  test "current_point should be present" do
    @user_point.current_point = nil
    assert_not @user_point.valid?
  end

  test "total_point should be present" do
    @user_point.total_point = nil
    assert_not @user_point.valid?
  end
end
