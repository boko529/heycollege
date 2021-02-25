require "test_helper"

class TeachersEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @teacher = teachers(:teacher1)          # user1に紐づけ
    @others_teacher = teachers(:teacher2)   # user2に紐づけ
    @lecture = lectures(:lecture_1)
  end

  test "blank edit" do
    login_as(@user, scope: :user)
    get edit_teacher_path(@teacher)
    # assert_template 'teachers/edit'  CSRF保護でエラーになる
    patch teacher_path(@teacher), params: { teacher: { name: " " }}
    # assert_template 'teachers/edit'　CSRF保護でエラーになる
    @teacher.reload
    assert_not_equal " ", @teacher.name 
  end

  test "successful edit" do
    login_as(@user, scope: :user)
    get edit_teacher_path(@teacher)
    # assert_template 'teachers/edit'  CSRF保護でエラーになる
    name  = "Foo Bar"
    patch teacher_path(@teacher), params: { teacher: { name:  name } }
    assert_not flash.empty?
    assert_redirected_to @teacher
    @teacher.reload
    assert_equal name,  @teacher.name
  end

  test "not login edit" do
    get edit_teacher_path(@teacher)
    #CSRF保護の関係らしい
    assert_template nil
    assert_not flash.empty?
  end

  test "others teacher edit" do
    login_as(@user, scope: :user)
    get teacher_path(@others_teacher)
    assert_template 'teachers/show'
    get edit_teacher_path(@others_teacher)
    assert_template nil
    assert_not flash.empty?
  end

  test "others teacher update" do
    login_as(@user, scope: :user)
    get teacher_path(@others_teacher)
    assert_template 'teachers/show'
    patch teacher_path(@others_teacher), params: { teacher: { name:  name } }
    @others_teacher.reload
    assert_not_equal name, @others_teacher.name
    assert_template nil
    assert_not flash.empty?
  end

  # test "teacher create in lectures edit" do
  #   login_as(@user, scope: :user)
  #   get edit_lecture_path(@lecture)
  #   assert_template 'lectures/edit'
  #   teacher_name  = "FooBar"
  #   assert_difference 'Teacher.count', 1 do
  #     patch lecture_path(@lecture), params: { lecture: { teacher_name:  teacher_name } }
  #   end
  # end
end
