require "test_helper"

class LecturesEditTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @others_lecture = lectures(:lecture_2)
    @valid_first_name = "太郎"
    @valid_last_name= "山田"
    @valid_teacher_name = @valid_last_name + " " + @valid_first_name
    @invalid_first_name = "はるか"
    @invalid_last_name = "中百舌鳥"
    @invalid_teacher_name  = @invalid_last_name + " " + @invalid_first_name
  end

  test "blank edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    patch lecture_path(@lecture), params: { lecture: { first_name: " ", last_name: " " }}
    assert_template 'lectures/edit'
  end

  test "successful edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    name  = "Foo Bar"
    patch lecture_path(@lecture), params: { lecture: { name: name, first_name: @valid_first_name, last_name: @valid_last_name} }
    assert_not flash.empty?
    assert_redirected_to @lecture
    @lecture.reload
    assert_equal name,  @lecture.name
    assert_equal @valid_teacher_name,  @lecture.teacher.name
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
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
  end

  test "others lecture update" do
    login_as(@user, scope: :user)
    get lecture_path(@others_lecture)
    assert_template 'lectures/show'
    patch lecture_path(@others_lecture), params: { lecture: { first_name: @valid_first_name, last_name: @valid_last_name} }
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
    @others_lecture.reload
    assert_not_equal @valid_teacher_name,  @others_lecture.teacher.name
  end

  test "teacher_name edit" do
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    patch lecture_path(@lecture), params: { lecture: { name: "name", first_name: @valid_first_name, last_name: @valid_last_name } }
    assert_not flash.empty?
    assert_redirected_to @lecture
    @lecture.reload
    assert_equal @valid_teacher_name,  @lecture.teacher.name
  end

  test "teacher_name(does not exist) edit" do
    # teacherを新規登録するためinvalidにならない.書き直すのが面倒なので、@invalidのままにしておく.
    login_as(@user, scope: :user)
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    assert_difference "Teacher.count", 1 do
      patch lecture_path(@lecture), params: { lecture: { name: "name", first_name: @invalid_first_name, last_name: @invalid_last_name } }
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_not flash.empty?
    @lecture.reload
    assert_equal @invalid_teacher_name,  @lecture.teacher.name
  end
end
