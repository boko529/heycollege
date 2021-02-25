require "test_helper"

class TeachersCreateTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
  end
  
  test "invalid name teacher create" do
    login_as(@user, scope: :user)
    get new_teacher_path
    assert_no_difference 'Teacher.count' do
      post teachers_path, params: { teacher: { name:  " "}}
    end
    assert_template 'teachers/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid teacher create" do
    login_as(@user, scope: :user)
    get new_teacher_path
    assert_difference 'Teacher.count', 1 do
      post teachers_path, params: { teacher: { name: "藤岡真由美" }}
    end
    follow_redirect!
    assert_template 'teachers/show'
    assert_not flash.empty?
  end

  test "teacher create in not login" do
    get new_teacher_path
    assert_template nil
    assert_not flash.empty?
  end

  # test "teacher create in lecture register" do
  #   login_as(@user, scope: :user)
  #   get new_lecture_path
  #   assert_difference 'Teacher.count', 1 do
  #     post lectures_path, params: { lecture: { name:  "日本大学史", language_used: "Japanese", lecture_type: "Language", lecture_term: "spring", lecture_size: "small", group_work: "included", teacher_name: "ExampleTeacher" } } # 存在していないExampleTeacherを自動生成
  #   end
  # end
end
