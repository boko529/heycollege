require "test_helper"

class HelpfulTest < ActiveSupport::TestCase
  def setup
    @user = users(:user2)
    @lecture = lectures(:lecture_1)
    @review = reviews(:review1)
    @helpful = Helpful.new(user_id: @user.id,review_id: @review.id)
  end

  test "helpful should be valid" do
    assert @helpful.valid?
  end

  test "helpful should have user id" do
    @helpful.user_id = nil
    assert_not @helpful.valid?
  end

  test "helpful should have review id" do
    @helpful.review_id = nil
    assert_not @helpful.valid?
  end

  test "should not same user and review" do
    @helpful.save
    @helpful2 = Helpful.new(user_id: @user.id,review_id: @review.id)
    assert_not @helpful2.valid?
  end
end
