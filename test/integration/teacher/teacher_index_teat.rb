require "test_helper"

class TeacherIndexTest < ActionDispatch::IntegrationTest
  def setup
    @teacher = lectures(:teacher_1)
  end
  
  test "index including pagination" do
    get teachers_path
    assert_template 'teachers/index'
    assert_select 'ul.pagination'
    assert_select 'a[href=?]', teacher_path(@teacher), text: @teacher.name_ja
  end
end