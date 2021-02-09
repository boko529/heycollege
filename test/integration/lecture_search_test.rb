require "test_helper"

class LectureIndexTest < ActionDispatch::IntegrationTest
  def setup
    @lecture = lectures(:lecture_1)
  end

  test "search_lecture_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { name_cont:  "行動経済学"}}
    assert_template 'lectures/index'
    assert_select 'a[href=?]', lecture_path(@lecture)
    assert_select 'li.lecture', count: 1
  end

  test "blank_search_lecture_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { name_cont:  ""}}
    assert_template 'lectures/index'
    assert_select 'li.lecture', count: 25
  end
end