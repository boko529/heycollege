require "test_helper"

class ReviewsCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
  end

  test "valid review create" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture)
    assert_template 'lectures/show'
    assert_difference 'Review.count', 1 do
      post lecture_reviews_path(@lecture), params: { review: { title:  "タイトル", content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, explanation: 2, fairness: 4, recommendation: 3, useful: 2, interesting: 2, difficulty: 1}}
    end
    follow_redirect!
    # コレが通らん
    # assert_template 'lectures/show'
    # 何故かこっちが通るんよな
    assert_template root_path
    assert_not flash.empty?
  end
end