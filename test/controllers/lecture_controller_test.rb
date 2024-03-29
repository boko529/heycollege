require "test_helper"

class LecturesControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @noreview_lecture = lectures(:lecture_2)
    @teacher = teachers(:teacher1)
  end

  # apu_lecture_reviews_pathにいっちゃう
  test "index including pagination" do
    login_as(@user, scope: :user)
    get lectures_path
    assert_template 'lectures/index'
    assert_select 'ul.pagination'
    assert_select 'a[href=?]', lecture_path(@lecture), text: @lecture.name_ja
  end

  # test "invalid name lecture create" do
  #   # 正確には先生は新規登録されるように変更したのでinvalidではない.
  #   login_as(@user, scope: :user)
  #   get new_lecture_path
  #   assert_difference 'Teacher.count', 1 do
  #     post lectures_path, params: { lecture: { name: "name", first_name:  "a", last_name: "b" }}
  #   end
  #   # follow_redirect! RuntimeErrorが起こる.
  #   # assert_template 'lectures/show'
  # end

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
    #詳細がなくても数には入れる
    assert_equal(4, @lecture.all_reviews_count)
    #詳細があるレビューのみviewに表示(詳細がないものは除く)
    assert_select 'li.review', count: 3
  end

  # test "blank name lecture create" do
  #   login_as(@user, scope: :user)
  #   get new_lecture_path
  #   assert_no_difference 'Lecture.count' do
  #     post lectures_path, params: { lecture: { first_name:  " ", last_name: " " }}
  #   end
  #   assert_template 'lectures/new'
  #   # assert_select 'div#error_explanation'  エラーはでない
  #   # assert_select 'div.alert.alert-danger' エラーはでない
  # end

  # test "new lecture with teacher_id params" do
  #   login_as(@user, scope: :user)
  #   get new_lecture_path(teacher_id: @teacher.id)
  #   assert_template "lectures/new"
  #   assert_equal @teacher.name, @lecture.teacher.name # 上で定義したものからコントローラで定義したやつに上書きされてるはず
  # end
end