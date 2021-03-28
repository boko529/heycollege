require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @user1 = users(:user1)
    @teacher = @user1.teachers.build(name_en: "ExampleTeacher")
  end

  test "should be valid" do
    assert @teacher.valid?
  end

  test "user id should be present" do
    @teacher.user_id = nil
    assert_not @teacher.valid?
  end

  test "name should be present" do
    @teacher.name_en = "   "
    assert_not @teacher.valid?
  end

  test "name should be at most 50 characters" do
    @teacher.name_en = "a" * 51
    assert_not @teacher.valid?
  end

  test "associated teachers should be destroyed" do
    @user1.save
    @user1.teachers.create!(name_en: "ExampleTeacher2")
    assert_difference 'Teacher.count', -2 do  # fixtureにuser1に紐づいたteacherを1人追加しているので2人消去される.
      @user1.destroy
    end
  end
end
