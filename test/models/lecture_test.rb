require "test_helper"

class LectureTest < ActiveSupport::TestCase
  def setup
    @lecture = Lecture.new(name: "行動経済学")
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
end
