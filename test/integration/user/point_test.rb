require "test_helper"

class User::PointTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user3)
  end

  test "user get point" do
    assert_difference "UserPointHistory.count", 1 do
      @user.point_get(point_type: 1, amount: 100)
    end
    assert_equal 110, @user.user_point.current_point
    assert_equal 110, @user.user_point.total_point
  end

  test "use point in enough point" do
    assert_difference "UserPointHistory.count", 1 do
      assert @user.point_use(point_type: 1, amount: 5)
    end
    assert_equal 5, @user.user_point.current_point
  end

  test "use point in not enough point" do
    assert_no_difference "UserPointHistory.count" do
      assert_not @user.point_use(point_type: 1, amount: 100)
    end
    assert_equal 10, @user.user_point.current_point
  end

  test "get helpful point" do
    assert_difference "UserPointHistory.count", 1 do
      assert @user.helpfuled_point
    end
    assert_equal 110, @user.user_point.current_point
    assert_equal 110, @user.user_point.total_point
  end

  test "get review point and d-point" do
    assert_difference "UserPointHistory.count", 1 do
      assert @user.review_point
    end
    assert_equal 20, @user.user_point.current_point
    assert_equal 20, @user.user_point.total_point
    # レビューを削除
    assert_difference "UserPointHistory.count", 1 do
      assert @user.review_d_point
    end
    assert_equal 10, @user.user_point.current_point
    assert_equal 10, @user.user_point.total_point
  end
end
