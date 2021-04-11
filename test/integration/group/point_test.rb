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
    # @user3つのグループに所属しているので3つ増える
    assert_difference "GroupPointHistory.count", 3 do
      assert @user.group_helpfuled_point
    end
    # 基本である100ポイント。3つのグループに所属しているので各々に33.3ポイント追加(元々は10ポイント)
    assert_equal 43.3, @group.group_point.current_point
    assert_equal 43.3, @group.group_point.total_point
  end
  
  # test "get helpful lecture point" do
  #   # @userが2つのグループに所属しているので2つ増える
  #   assert_difference "GroupPointHistory.count", 2 do
  #     assert @user.group_helpfuled_lecture_point
  #   end
  #   # 基本である1ポイント。2つのグループに所属しているので各々に0.5ポイント追加(元々は10ポイント)
  #   assert_equal 10.5, @group.group_point.current_point
  #   assert_equal 10.5, @group.group_point.total_point
  # end

  # test "get helpful teacher point" do
  #   # @userが2つのグループに所属しているので2つ増える
  #   assert_difference "GroupPointHistory.count", 2 do
  #     assert @user.group_helpfuled_teacher_point
  #   end
  #   # 基本である1ポイント。2つのグループに所属しているので各々に0.5ポイント追加(元々は10ポイント)
  #   assert_equal 10.5, @group.group_point.current_point
  #   assert_equal 10.5, @group.group_point.total_point
  # end

  test "get review point" do
    # @userが2つのグループに所属しているので2つ増える
    assert_difference "GroupPointHistory.count", 3 do
      assert @user.group_review_point
    end
    # 基本である10ポイント。3つのグループに所属しているので各々に3.3ポイント追加(元々は10ポイント)
    assert_equal 13.3, @group.group_point.current_point
    assert_equal 13.3, @group.group_point.total_point
    # レビューを削除
    assert_difference "GroupPointHistory.count", 3 do
      assert @user.group_review_d_point
    end
    assert_equal 10, @user.user_point.current_point
    assert_equal 10, @user.user_point.total_point
  end

end
