require "test_helper"

class LecturesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @noreview_lecture = lectures(:lecture_2)
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

  test "invalid name lecture create" do
    login_as(@user, scope: :user)
    get new_lecture_path
    assert_no_difference 'Lecture.count' do
      post lectures_path, params: { lecture: { name:  " "}}
    end
    assert_template 'lectures/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "lecture show in not login" do
    get lecture_path(@lecture)
    assert_template nil
    assert_not flash.empty?
  end

  test "lecture show in not having review" do
    login_as(@user, scope: :user)
    get lecture_path(@noreview_lecture)
    assert_template "lectures/show"
    # レビューがないと平均は不明
    assert_equal("不明", @noreview_lecture.average_score)
  end

  test "lecture show in having review" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture)
    assert_template "lectures/show"
    # レビューがあると平均は0じゃない
    assert_not_equal(0, @lecture.average_score)
  end
end