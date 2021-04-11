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
    assert_difference 'GroupPointHistory.count', 3 do
      assert_difference 'UserPointHistory.count', 1 do
        assert_difference 'Review.count', 1 do
          post lecture_reviews_path(@lecture), params: { review: { content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, score: 1}}
        end
      end
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end

  # レビューにコンテントがないときはポイントの付与はなし
  test "valid review create without content" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture)
    assert_template 'lectures/show'
    assert_no_difference 'GroupPointHistory.count' do
      assert_no_difference 'UserPointHistory.count' do
        assert_difference 'Review.count', 1 do
          post lecture_reviews_path(@lecture), params: { review: { content: nil, user_id: @user.id, lecture_id: @lecture.id, score: 1}}
        end
      end
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end
end