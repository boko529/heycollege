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
      post lectures_path, params: { lecture: { name:  "日本大学史", first_name: "直樹", last_name: "森"} } # teacher_nameから自動的にteacher_idを推定してくれる.
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end

  test "valid lecture create when its teacher does not exist" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_difference 'Lecture.count', 1 do
      assert_difference 'Teacher.count', 1 do
        post lectures_path, params: { lecture: { name:  "日本大学史", first_name: "Teacher", last_name: "Example" } } # ExampleTeacherは存在しない.
      end
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end

  test "do not save teacher when lecture name is blank" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_no_difference 'Teacher.count' do
      post lectures_path, params: { lecture: { name:  "  ", first_name: "Teacher", last_name: "Example" } } # ExampleTeacherは存在しない.
    end
    assert_template 'lectures/new'
  end
end
