require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  def setup
    @user = users(:user2)
    @review = reviews(:review1)
    @notification = Notification.new(visitor_id: @user, visited_id: @review.user, review_id: @review.id)
  end

  test "should be valid" do
    @notification.valid?
  end
end
