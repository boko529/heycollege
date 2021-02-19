require "test_helper"

class LecturesCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @teacher = teachers(:teacher1)
  end

  test "valid lecture create" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_difference 'Lecture.count', 1 do
      post lectures_path, params: { lecture: { name:  "日本大学史", language_used: "Japanese", lecture_type: "Language", lecture_term: "spring", lecture_size: "small", group_work: "included", user_id: @user.id, teacher_id: @teacher.id} }
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end
end
