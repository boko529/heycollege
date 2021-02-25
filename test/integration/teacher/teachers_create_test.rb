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
      post teachers_path, params: { teacher: { first_name:  " ", last_name: " "}}
    end
    assert_template 'teachers/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid teacher create" do
    login_as(@user, scope: :user)
    get new_teacher_path
    assert_difference 'Teacher.count', 1 do
      post teachers_path, params: { teacher: { first_name: "真由美", last_name: "藤岡" }}
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
end
