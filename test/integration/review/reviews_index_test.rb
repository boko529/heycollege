require "test_helper"

class ReviewsIndexTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    login_as(@user, scope: :user)
  end

  test "reviews_display" do
    get lecture_path(@lecture)
    assert_template "lectures/show"
    assert_select 'ol.reviews'
    assert_select 'li.review'
  end
end
