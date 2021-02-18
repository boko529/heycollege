require "test_helper"

class HelpfulsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @lecture = lectures(:lecture_1)
    @review = reviews(:review1)
  end

  test "valid create helpful" do
    login_as(@user2, scope: :user)
    assert_difference 'Helpful.count', 1 do
      post lecture_review_helpfuls_path(@lecture, @review), params: { helpful: {lecture_id: @lecture.id, review_id: @review.id }}
    end
    assert_template "helpfuls/create"
  end

  test "create helpful for myself lecture" do
    login_as(@user1, scope: :user)
    assert_no_difference 'Helpful.count' do
      post lecture_review_helpfuls_path(@lecture, @review), params: { helpful: {lecture_id: @lecture.id, review_id: @review.id }}
    end
    assert_not flash.empty?
  end

  test "create helpful in not login" do
    post lecture_review_helpfuls_path(@lecture, @review), params: { helpful: {lecture_id: @lecture.id, review_id: @review.id }}
    assert_not flash.empty?
    assert_template nil
  end

end
