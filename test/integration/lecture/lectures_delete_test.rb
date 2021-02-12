require "test_helper"

class LecturesDeleteTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @others_lecture = lectures(:lecture_2)
  end

  test "successful delete" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture)
    assert_template 'lectures/show'
    assert_difference 'Lecture.count', -1 do
      delete lecture_path(@lecture)
    end
    #CSRF保護の関係でlecture/indexでは通らないらしい
    assert_template nil
    assert_not flash.empty?
  end

  test "Not login delete" do
    get lecture_path(@lecture)
    assert_difference 'Lecture.count', 0 do
      delete lecture_path(@lecture)
    end
    #CSRF保護の関係でlecture/indexでは通らないらしい
    assert_template nil
    assert_not flash.empty?
  end

  test "others lecture delete" do
    login_as(@user, scope: :user)
    get lecture_path(@others_lecture)
    assert_template 'lectures/show'
    assert_no_difference 'Lecture.count' do 
      delete lecture_path(@others_lecture)
    end
    #CSRF保護の関係でlecture/indexでは通らないらしい
    assert_template nil
    assert_not flash.empty?
  end
end