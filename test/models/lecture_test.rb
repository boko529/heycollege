require "test_helper"

class LectureTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @lecture = @user.lectures.build(name:  "日本大学史", language_used: "Japanese", lecture_type: "Language", lecture_term: "spring", lecture_size: "small", group_work: "included", user_id: @user.id)
  end
  
  test "should be valid" do
    assert @lecture.valid?
  end

  test "lecture name should be present" do
    @lecture.name = nil
    assert_not @lecture.valid?
  end

  test "name should not be too long" do
    @lecture.name = "a" * 21
    assert_not @lecture.valid?
  end

  test "name should be unique" do
    duplicate_lecture = @lecture.dup
    @lecture.save
    assert_not duplicate_lecture.valid?
  end

  test "language_used should be present" do
    @lecture.language_used = nil
    assert_not @lecture.valid?
  end

  test "lecture_type should be present" do
    @lecture.lecture_type = nil
    assert_not @lecture.valid?
  end

  test "lecture_term should be present" do
    @lecture.lecture_term = nil
    assert_not @lecture.valid?
  end

  test "lecture_size should be present" do
    @lecture.lecture_term = nil
    assert_not @lecture.valid?
  end
end
