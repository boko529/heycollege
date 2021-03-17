require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  def setup
    @user = users(:user2)
    @lecture = lectures(:lecture_1)
    @bookmark = Bookmark.new(user_id: @user.id, lecture_id: @lecture.id)
  end

  test "bookmark should be valid" do
    assert @bookmark.valid?
  end

  test "bookmark should have user id" do
    @bookmark.user_id = nil
    assert_not @bookmark.valid?
  end

  test "bookmark should have lecture id" do
    @bookmark.lecture_id = nil
    assert_not @bookmark.valid?
  end

  test "should not same user and lecture" do
    @bookmark.save
    @bookmark2 = Bookmark.new(user_id: @user.id,lecture_id: @lecture.id)
    assert_not @bookmark2.valid?
  end
end
