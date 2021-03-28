require "test_helper"

class LectureTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @teacher = teachers(:teacher1)
    @teacher2 = teachers(:teacher2)
    @lecture = @user.lectures.build(name_ja:  "日本大学史", name_en: "History", lecture_lang: "ja", field: "APS", user_id: @user.id, teacher_id: @teacher.id)
  end
  
  test "should be valid" do
    assert @lecture.valid?
  end

  test "name_ja or name_en should be present" do
    @lecture.name_ja = nil
    @lecture.name_en = nil
    assert_not @lecture.valid?
  end

  test "name_ja should not be too long" do
    @lecture.name_ja = "a" * 51
    assert_not @lecture.valid?
  end

  test "name_en should not be too long" do
    @lecture.name_en = "a" * 51
    assert_not @lecture.valid?
  end

  test "name_ja(& teacher_id) should be unique" do
    duplicate_lecture = @lecture.dup
    @lecture.save
    duplicate_lecture.name_en = "foobar"
    assert_not duplicate_lecture.valid?
  end

  test "name_en(& teacher_id) should be unique" do
    duplicate_lecture = @lecture.dup
    @lecture.save
    duplicate_lecture.name_ja = "foobar"
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

  test "feild should be present" do
    @lecture.field = nil
    assert_not @lecture.valid?
  end

  test "lecture_lang should be present" do
    @lecture.lecture_lang = nil
    assert_not @lecture.valid?
  end
end
