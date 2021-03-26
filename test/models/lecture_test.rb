require "test_helper"

class LectureTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @teacher = teachers(:teacher1)
    @teacher2 = teachers(:teacher2)
    @lecture = @user.lectures.build(name_ja:  "日本大学史", user_id: @user.id, teacher_id: @teacher.id)
  end
  
  test "should be valid" do
    assert @lecture.valid?
  end

  test "lecture name should be present" do
    @lecture.name_ja = nil
    assert_not @lecture.valid?
  end

  test "name should not be too long" do
    @lecture.name_ja = "a" * 51
    assert_not @lecture.valid?
  end

  test "name(& teacher_id) should be unique" do
    duplicate_lecture = @lecture.dup
    @lecture.save
    assert_not duplicate_lecture.valid?
  end

  test "name (teacher_id different) shoud not be unique" do
    duplicate_lecture = @lecture.dup
    duplicate_lecture.teacher_id = @teacher2.id
    @lecture.save
    assert duplicate_lecture.valid?
  end

  test "teacher_id should be present" do
    @lecture.teacher_id = nil
    assert_not @lecture.valid?
  end
end
