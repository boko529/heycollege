require "test_helper"

class Group::PointTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @group = groups(:group2)
  end

  test "group get point" do
    assert_difference "GroupPointHistory.count", 1 do
      @group.point_get(point_type: 1, amount: 100)
    end
    assert_equal 110, @group.group_point.current_point
    assert_equal 110, @group.group_point.total_point
  end

  test "use point in enough point" do
    assert_difference "GroupPointHistory.count", 1 do
      assert @group.point_use(point_type: 1, amount: 5)
    end
    assert_equal 5, @group.group_point.current_point
  end

  test "use point in not enough point" do
    assert_no_difference "GroupPointHistory.count" do
      assert_not @group.point_use(point_type: 1, amount: 100)
    end
    assert_equal 10, @group.group_point.current_point
  end

  test "get helpful point" do
    # @userが2つのグループに所属しているので2つ増える
    assert_difference "GroupPointHistory.count", 2 do
      assert @user.group_helpfuled_point
    end
    # 基本である100ポイント。2つのグループに所属しているので各々に50ポイント追加(元々は10ポイント)
    assert_equal 60, @group.group_point.current_point
    assert_equal 60, @group.group_point.total_point
  end
  
  test "get helpful lecture point" do
    # @userが2つのグループに所属しているので2つ増える
    assert_difference "GroupPointHistory.count", 2 do
      assert @user.group_helpfuled_lecture_point
    end
    # 基本である1ポイント。2つのグループに所属しているので各々に0.5ポイント追加(元々は10ポイント)
    assert_equal 10.5, @group.group_point.current_point
    assert_equal 10.5, @group.group_point.total_point
  end

  test "get helpful teacher point" do
    # @userが2つのグループに所属しているので2つ増える
    assert_difference "GroupPointHistory.count", 2 do
      assert @user.group_helpfuled_teacher_point
    end
    # 基本である1ポイント。2つのグループに所属しているので各々に0.5ポイント追加(元々は10ポイント)
    assert_equal 10.5, @group.group_point.current_point
    assert_equal 10.5, @group.group_point.total_point
  end
end
