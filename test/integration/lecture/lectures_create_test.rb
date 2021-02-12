require "test_helper"

class LecturesCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
  end
  
  test "invalid name lecture create" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_no_difference 'Lecture.count' do
      post lectures_path, params: { lecture: { name:  " "}}
    end
    assert_template 'lectures/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid lecture create" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_difference 'Lecture.count', 1 do
      post lectures_path, params: { lecture: { name:  "日本大学史", language_used: "Japanese", lecture_type: "Language", lecture_term: "spring", lecture_size: "small", group_work: "included", user_id: @user.id}}
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end

  test "lecture create in not login" do
    get new_lecture_path
    assert_template nil
    assert_not flash.empty?
  end
end
