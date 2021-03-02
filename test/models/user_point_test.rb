require "test_helper"

class UserPointTest < ActiveSupport::TestCase
  def setup
    @user = users(:user3)
    @user_point = @user.user_points.build(current_point: 10, total_point: 10)
  end

  test "should be valid" do
    assert @user_point.valid?
  end
end
