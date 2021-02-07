require "test_helper"

class LecturesEditTest < ActionDispatch::IntegrationTest
  def setup
    @lecture = lectures(:one)
  end

  test "unsuccessful edit" do
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    patch lecture_path(@lecture), params: { lecture: { name: " " }}
    assert_template 'lectures/edit'
  end

  test "successful edit" do
    get edit_lecture_path(@lecture)
    assert_template 'lectures/edit'
    name  = "Foo Bar"
    patch lecture_path(@lecture), params: { lecture: { name:  name } }
    assert_not flash.empty?
    assert_redirected_to @lecture
    @lecture.reload
    assert_equal name,  @lecture.name
  end
end
