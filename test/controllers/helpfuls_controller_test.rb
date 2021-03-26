require "test_helper"

class HelpfulsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user1 = users(:user1) #grouop1とgroup2に所属
    @user2 = users(:user2) #group1に所属
    @lecture = lectures(:lecture_1) #user1が作成した講義
    @review = reviews(:review1) #user1がlecture1に投稿したレビュー
    @review2 = reviews(:review3) # reviewの書き手がgroupに無所属
  end

  test "valid create helpful with group" do
    login_as(@user2, scope: :user)
    #参考になるによってお知らせ、参考になる、ポイント履歴の数が増える。レビューの書き手は2つのグループに所属しているのでGroupPointHistoryは2つ増える
    assert_difference 'GroupPointHistory.count', 2 do
      assert_difference 'UserPointHistory.count', 1 do
        assert_difference 'Notification.count', 1 do
          assert_difference 'Helpful.count', 1 do
            post lecture_review_helpfuls_path(@lecture, @review), params: { helpful: {lecture_id: @lecture.id, review_id: @review.id }}
          end
        end
      end
    end
    assert_template "helpfuls/create"
  end

  test "valid create helpful without group" do
    login_as(@user2, scope: :user)
    #参考になるによってお知らせ、参考になる、ポイント履歴の数が増える。書き手はグループに所属していないのでポイントヒストリーは増えない
    assert_no_difference 'GroupPointHistory.count' do
      assert_difference 'UserPointHistory.count', 1 do
        assert_difference 'Notification.count', 1 do
          assert_difference 'Helpful.count', 1 do
            post lecture_review_helpfuls_path(@lecture, @review2), params: { helpful: {lecture_id: @lecture.id, review_id: @review2.id }}
          end
        end
      end
    end
    assert_template "helpfuls/create"
  end

  test "create helpful for myself lecture" do
    login_as(@user1, scope: :user)
    assert_no_difference 'Helpful.count' do
      post lecture_review_helpfuls_path(@lecture, @review), params: { helpful: {lecture_id: @lecture.id, review_id: @review.id }}
    end
    assert_not flash.empty?
  end

  test "create helpful in not login" do
    assert_no_difference 'Helpful.count' do
      post lecture_review_helpfuls_path(@lecture, @review), params: { helpful: {lecture_id: @lecture.id, review_id: @review.id }}
    end
    assert_not flash.empty?
    assert_template nil
  end

end
