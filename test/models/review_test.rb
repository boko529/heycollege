require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @review = @user.reviews.build(title: "タイトル", content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, explanation: 3,fairness: 4, recommendation: 2, useful: 1, interesting: 4, difficulty: 3, score: 2.8)
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

  test "explanation should be present" do
    @review.explanation = nil
    assert_not @review.valid?
  end
  
  test "explanation should be figure" do
    @review.explanation = "a"
    assert_not @review.valid?
  end

  test "explanation should be more than 1" do
    @review.explanation = 0
    assert_not @review.valid?
  end

  test "explanation should be less than 5" do
    @review.explanation = 6
    assert_not @review.valid?
  end

  test "fairness should be present" do
    @review.fairness = nil
    assert_not @review.valid?
  end

  test "fairness should be figure" do
    @review.fairness = "a"
    assert_not @review.valid?
  end

  test "fairness should be more than 1" do
    @review.fairness = 0
    assert_not @review.valid?
  end

  test "fairness should be less than 5" do
    @review.fairness = 6
    assert_not @review.valid?
  end

  test "recommendation should be present" do
    @review.recommendation = nil
    assert_not @review.valid?
  end

  test "recommendation should be figure" do
    @review.recommendation = "a"
    assert_not @review.valid?
  end

  test "recommendation should be more than 1" do
    @review.recommendation = 0
    assert_not @review.valid?
  end

  test "recommendation should be less than 5" do
    @review.recommendation = 6
    assert_not @review.valid?
  end

  test "useful should be present" do
    @review.useful = nil
    assert_not @review.valid?
  end

  test "useful should be figure" do
    @review.useful = "a"
    assert_not @review.valid?
  end

  test "useful should be more than 1" do
    @review.useful = 0
    assert_not @review.valid?
  end

  test "useful should be less than 5" do
    @review.useful = 6
    assert_not @review.valid?
  end

  test "interesting should be present" do
    @review.interesting = nil
    assert_not @review.valid?
  end

  test "interesting should be figure" do
    @review.interesting = nil
    assert_not @review.valid?
  end

  test "interesting should be more than 1" do
    @review.interesting = 0
    assert_not @review.valid?
  end

  test "interesting should be less than 5" do
    @review.interesting = 6
    assert_not @review.valid?
  end

  test "difficulty should be present" do
    @review.difficulty = nil
    assert_not @review.valid?
  end

  test "difficulty should be figure" do
    @review.difficulty = nil
    assert_not @review.valid?
  end

  test "difficulty should be more than 1" do
    @review.difficulty = 0
    assert_not @review.valid?
  end

  test "difficulty should be less than 5" do
    @review.difficulty = 6
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
