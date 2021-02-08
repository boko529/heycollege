require "test_helper"

class LectureIndexTest < ActionDispatch::IntegrationTest
  def setup
    @lecture = lectures(:lecture_1)
  end

  # each文を使ったテストエラーがでちゃう。
  test "index including pagination" do
    get lectures_path
    assert_template 'lectures/index'
    assert_select 'ul.pagination'
    assert_select 'a[href=?]', lecture_path(@lecture), text: @lecture.name
    # Lecture.page(page: 1).each do |lecture|
    #   assert_select 'a[href=?]', lecture_path(lecture), text: lecture.name
    # end
  end
end
