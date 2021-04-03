require "test_helper"

class LectureIndexTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @lecture2 = lectures(:lecture_2)
  end

  test "search_lecture_by_name_from_root" do
    login_as(@user, scope: :user)
    get lectures_path, params: { q: { name_ja_cont:  "行動経済学"}}
    assert_template 'lectures/index'
    assert_select 'a[href=?]', lecture_path(@lecture)
    assert_select 'div.lecture', count: 1
  end
  
  test "search_lecture_by_teacher_name_from_root" do
    login_as(@user, scope: :user)
    get lectures_path, params: { q: { teacher_name_ja_cont:  "橋本 虎太郎"}}
    assert_template 'lectures/index'
    assert_select 'a[href=?]', lecture_path(@lecture2)
    assert_select 'div.lecture', count: 1
  end

  test "blank_name_search_lecture_from_root" do
    login_as(@user, scope: :user)
    get lectures_path, params: { q: { name_ja_cont:  ""}}
    assert_template 'lectures/index'
    assert_select 'div.lecture', count: 20
  end

  test "should_login" do
    get lectures_path, params: { q: { name_ja_cont:  ""}}
    assert_template nil
    assert_select 'div.lecture', count: 0
  end
end