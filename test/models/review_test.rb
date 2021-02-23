require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @review = @user.reviews.build(title: "タイトル", content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, score: 3.0)
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
    @review.content= "a" * 601
    assert_not @review.valid?
  end

  test "score should be present" do
    @review.score = nil
    assert_not @review.valid?
  end

  test "score should be figure" do
    @review.score = nil
    assert_not @review.valid?
  end

  test "score should be more than 1" do
    @review.score = 0
    assert_not @review.valid?
  end

  test "score should be less than 5" do
    @review.score = 6
    assert_not @review.valid?
  end
end
