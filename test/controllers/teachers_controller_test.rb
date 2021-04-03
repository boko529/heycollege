require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @opu_user = users(:other_university_user)
    @teacher = teachers(:teacher1)
  end

  test "valid teacher show" do
    login_as(@user, scope: :user)
    get teacher_path(@teacher)
    assert_template "teachers/show"
  end

  test "need login" do
    get teacher_path(@teacher)
    assert_template nil
    assert_not flash.empty?
  end

  test "should not show other university teacher" do
    login_as(@opu_user, scope: :user)
    get teacher_path(@teacher)
    follow_redirect!
    assert_template "zooms/index" # rootページへ
  end
end
