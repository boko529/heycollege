require "test_helper"

class ReviewNotificationTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @other_user = users(:user2)
    @review = reviews(:review1)
  end

  test "display circle when new notification" do
    login_as(@user, scope: :user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'i.fas.fa-circle.n-circle.fa-2x', 0
    assert_difference 'Notification.count', 1 do
      Notification.create!(visitor_id: @other_user.id, visited_id: @review.user.id, review_id: @review.id)
    end
    # ページの再読み込み(リロード)をしています
    get root_path
    assert_template 'static_pages/home'
    #新着メッセージのオレンジ色の丸の確認
    assert_select 'i.fas.fa-circle.n-circle', 1
    # お知らせ一覧に移動、オレンジ色の丸が消えていることを確認
    get notifications_path
    assert_template "notifications/index"
    assert_select 'i.fas.fa-circle.n-circle', 0
  end
end
