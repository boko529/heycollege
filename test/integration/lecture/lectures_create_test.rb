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
      post lectures_path, params: { lecture: { name:  "日本大学史", language_used: "Japanese", lecture_type: "Language", lecture_term: "spring", lecture_size: "small", group_work: "included", teacher_name: "ET1"} } # teacher_nameから自動的にteacher_idを推定してくれる.
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end

  test "invalid lecture create when its teacher does not exist" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_difference 'Lecture.count', 0 do
      post lectures_path, params: { lecture: { name:  "日本大学史", language_used: "Japanese", lecture_type: "Language", lecture_term: "spring", lecture_size: "small", group_work: "included", teacher_name: "ExampleTeacher" } } # ExampleTeacherは存在しない.
    end
  end

end
