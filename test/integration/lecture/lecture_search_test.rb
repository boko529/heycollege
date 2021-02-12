require "test_helper"

class LectureIndexTest < ActionDispatch::IntegrationTest
  def setup
    @lecture = lectures(:lecture_1)
  end

  test "search_lecture_by_name_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { name_cont:  "行動経済学"}}
    assert_template 'lectures/index'
    assert_select 'a[href=?]', lecture_path(@lecture)
    assert_select 'li.lecture', count: 1
  end

  test "search_lecture_by_Japanese_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { language_used_eq: 0}}
    assert_template 'lectures/index'
  end

  test "search_lecture_by_lecture_type_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { lecture_type_eq: 0}}
    assert_template 'lectures/index'
  end

  test "search_lecture_by_lecture_size_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { lecture_size_eq: 0}}
    assert_template 'lectures/index'
  end

  test "search_lecture_by_lecture_term_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { lecture_term_eq: 0}}
    assert_template 'lectures/index'
  end

  test "blank_name_search_lecture_from_root" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'form#lecture_search'
    get lectures_path, params: { q: { name_cont:  ""}}
    assert_template 'lectures/index'
    assert_select 'li.lecture', count: 25
  end

  
end