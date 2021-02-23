require "test_helper"

class LecturesCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
  end

  test "valid lecture create" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_difference 'Lecture.count', 1 do
      post lectures_path, params: { lecture: { name:  "日本大学史", user_id: @user.id}}
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end
end
