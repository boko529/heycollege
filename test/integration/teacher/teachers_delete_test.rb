require "test_helper"

class TeachersDeleteTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @teacher = teachers(:teacher1)
    @others_teacher = teachers(:teacher2)
  end

  test "successful delete" do
    login_as(@user, scope: :user)
    get teacher_path(@teacher)
    assert_template 'teachers/show'
    assert_difference 'Teacher.count', -1 do
      delete teacher_path(@teacher)
    end
    #CSRF保護の関係でteacher/indexでは通らないらしい
    assert_template nil
    assert_not flash.empty?
  end

  test "Not login delete" do
    get teacher_path(@teacher)
    assert_difference 'Teacher.count', 0 do
      delete teacher_path(@teacher)
    end
    #CSRF保護の関係でteacher/indexでは通らないらしい
    assert_template nil
    assert_not flash.empty?
  end

  test "others teacher delete" do
    login_as(@user, scope: :user)
    get teacher_path(@others_teacher)
    assert_template 'teachers/show'
    assert_no_difference 'Teacher.count' do 
      delete teacher_path(@others_teacher)
    end
    #CSRF保護の関係でlecture/indexでは通らないらしい
    assert_template nil
    assert_not flash.empty?
  end
end
