require "test_helper"

class ReviewsCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_2)
  end

  test "valid review create" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture)
    assert_template 'lectures/show'
    assert_difference 'Review.count', 1 do
      post lecture_reviews_path(@lecture), params: { review: { content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, score: 1}}
    end
    follow_redirect!
    assert_template 'reviews/show'
    assert_not flash.empty?
  end
end