require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @user1 = users(:user1)
    # このコードは慣習的に正しくない
    @teacher = @user1.teachers.build(name: "ExampleTeacher")
  end

  test "should be valid" do
    assert @teacher.valid?
  end

  test "user id should be present" do
    @teacher.user_id = nil
    assert_not @teacher.valid?
  end

  test "name should be present" do
    @teacher.name = "   "
    assert_not @teacher.valid?
  end

  test "name should be at most 50 characters" do
    @teacher.name = "a" * 51
    assert_not @teacher.valid?
  end

  test "associated teachers should be destroyed" do
    @user1.save
    @user1.teachers.create!(name: "ExampleTeacher2")
    assert_difference 'Teacher.count', -1 do
      @user1.destroy
    end
  end
end
