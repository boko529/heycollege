require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user1 = User.new(name: "ExampleUser", email: "user@example.com",password: "foobar",password_confirmation: "foobar")
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

end
