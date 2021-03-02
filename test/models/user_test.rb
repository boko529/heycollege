require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user1 = User.new(name: "ExampleUser", email: "user@example.com",password: "foobar",password_confirmation: "foobar")
    @teacher = teachers(:teacher1)
  end

  test "should be valid" do
    assert @user1.valid?
  end

  test "name should be present" do
    @user1.name = " "
    assert_not @user1.valid?
  end

  test "email should be present" do
    @user1.email = " "
    assert_not @user1.valid?
  end

  test "email should not be too long" do
    @user1.email = "a" * 244 + "@example.com"
    assert_not @user1.valid?
  end

  test "name should not be too long" do
    @user1.name = "a" * 51
    assert_not @user1.valid?
  end

  test "password should be present (nonblank)" do
    @user1.password = @user1.password_confirmation = " " * 6
    assert_not @user1.valid?
  end
  
  test "password should have a minimum length" do
    @user1.password = @user1.password_confirmation = "a" * 5
    assert_not @user1.valid?
  end

  test "associated lectures should be destroyed" do
    @user1.skip_confirmation!
    @user1.save
    @user1.lectures.create!(name:  "日本大学史", teacher_id: @teacher.id)
    assert_difference 'Lecture.count', -1 do
      @user1.destroy
    end
  end

  test "associated user_point should be destroyed" do
    @user1.skip_confirmation!
    assert @user1.confirmed?
    @user1.save
    @user_point = @user1.build_user_point(current_point: 10, total_point: 10)
    @user_point.save
    assert_difference 'User.count', -1 do
      assert_difference 'UserPoint.count', -1 do
        @user1.destroy
      end
    end
  end

  test "sign up user don't have twitter_url" do
    assert_not @user1.twitter_url.present?
  end

end
