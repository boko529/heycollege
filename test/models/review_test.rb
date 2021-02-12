require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @review = @user.reviews.build(title: "タイトル", content: "コンテント", user_id: @user.id, lecture_id: @lecture.id)
  end

  test "should be valid" do
    assert @review.valid?
  end

  test "title should be present" do
    @review.title = nil
    assert_not @review.valid?
  end

  test "title should not be blank" do
    @review.title = ' '
    assert_not @review.valid?
  end

  test "title should not be too long" do
    @review.title = "a" * 21
    assert_not @review.valid?
  end

  test "content should be present" do
    @review.content = nil
    assert_not @review.valid?
  end

  test "content should not be blank" do
    @review.content = ' '
    assert_not @review.valid?
  end

  test "content should not be too long" do
    @review.content= "a" * 301
    assert_not @review.valid?
  end
end
