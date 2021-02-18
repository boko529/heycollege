require "test_helper"

class ReviewNotificationTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @other_user = users(:user2)
    @review = reviews(:review1)
    @notification = Notification.new(visitor_id: @other_user, visited_id: @review.user, review_id: @review.id)
  end

  test "display circle when new notification" do
    login_as(@user, scope: :user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'i.fas.fa-circle.n-circle.fa-2x', 0
    assert_difference 'Notification.count', 1 do
      @notification.save
    end
    assert_select 'i.fas.fa-circle.n-circle.fa-2x', 1
  end
end
