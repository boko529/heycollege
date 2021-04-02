require "test_helper"

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @university = universities(:one)
    @other_university = universities(:two)
    @user1 = users(:user1)
    @teacher = @user1.teachers.build(name_ja: "サンプル先生",name_en: "ExampleTeacher", university_id: @university.id)
  end

  test "should be valid" do
    assert @teacher.valid?
  end

  test "user id should be present" do
    @teacher.user_id = nil
    assert_not @teacher.valid?
  end

  test "name_en should be present" do
    @teacher.name_en = "   "
    assert_not @teacher.valid?
  end

  test "name_ja should be present" do
    @teacher.name_ja = "   "
    assert_not @teacher.valid?
  end
  
  test "name_ja should be at most 50 characters" do
    @teacher.name_ja = "a" * 51
    assert_not @teacher.valid?
  end
  
  test "name_en should be at most 50 characters" do
    @teacher.name_en = "a" * 51
    assert_not @teacher.valid?
  end
  
  test "associated teachers should be destroyed" do
    @user1.teachers.create!(name_ja: "サンプル先生2",name_en: "ExampleTeacher2", university_id: @university.id)
    assert_difference 'Teacher.count', -2 do  # fixtureにuser1に紐づいたteacherを1人追加しているので2人消去される.
      @user1.destroy
    end
  end
  
  test "name (university_id different) shoud not be unique" do
    duplicate_teacher = @teacher.dup
    duplicate_teacher.university_id = @other_university.id
    @teacher.save
    assert duplicate_teacher.valid?
  end

  test "university_id should be present" do
    @teacher.university_id = nil
    assert_not @teacher.valid?
  end
end
