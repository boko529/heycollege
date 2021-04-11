require "test_helper"

class Review::ReviewDestroyTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @review = reviews(:review1)
  end

  test "review destroy with content" do
    login_as(@user, scope: :user)
    assert_difference 'GroupPointHistory.count', 3 do
      assert_difference 'UserPointHistory.count', 1 do
        assert_difference 'Review.count', -1 do
          delete lecture_review_path(@lecture.id, @review.id)
        end
      end
    end
    assert_not flash.empty?
    follow_redirect!
    assert_template "lectures/show"
  end
end
