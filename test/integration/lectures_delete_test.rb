require "test_helper"

class LecturesEditTest < ActionDispatch::IntegrationTest
  def setup
    @lecture = lectures(:lecture_1)
  end

  test "successful delete" do
    get lecture_path(@lecture)
    assert_template 'lectures/show'
    assert_select 'a[href=?]', lecture_path(@lecture)
    assert_difference 'Lecture.count', -1 do
      delete lecture_path(@lecture)
    end
    assert_not flash.empty?
  end
end
