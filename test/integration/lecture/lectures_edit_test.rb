require "test_helper"

class LecturesEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @others_lecture = lectures(:lecture_2)
  end

  test "blank edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    patch lecture_path(@lecture), params: { lecture: { name: " " }}
    assert_template 'lectures/edit'
  end

  test "successful edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    name  = "Foo Bar"
    patch lecture_path(@lecture), params: { lecture: { name:  name } }
    assert_not flash.empty?
    assert_redirected_to @lecture
    @lecture.reload
    assert_equal name,  @lecture.name
  end

  test "not login edit" do
    get edit_lecture_path(@lecture)
    #CSRF保護の関係らしい
    assert_template nil
    assert_not flash.empty?
  end

  test "others lecture edit" do
    login_as(@user, scope: :user)
    get lecture_path(@others_lecture)
    assert_template 'lectures/show'
    get edit_lecture_path(@others_lecture)
    assert_template nil
    assert_not flash.empty?
  end

  test "others lecture update" do
    login_as(@user, scope: :user)
    get lecture_path(@others_lecture)
    assert_template 'lectures/show'
    patch lecture_path(@others_lecture), params: { lecture: { name:  name } }
    assert_template nil
    assert_not flash.empty?
  end

  test "teacher_name edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    teacher_name  = "ET1"
    patch lecture_path(@lecture), params: { lecture: { teacher_name:  teacher_name } }
    assert_not flash.empty?
    assert_redirected_to @lecture
    @lecture.reload
    assert_equal teacher_name,  @lecture.teacher_name
  end

  test "teacher_name(does not exist) edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    teacher_name  = "FooBar"
    patch lecture_path(@lecture), params: { lecture: { teacher_name:  teacher_name } }
    assert flash.empty?
  end
end
