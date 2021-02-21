require "test_helper"

class Admin::NewsTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @admin_user = users(:test_admin)
    @news = news(:news1)
  end

  test "create news" do
    login_as(@admin_user)
    # 既にnewsがあると作れない
    get new_admin_news_path
    assert_template 'admin/news/new'
    assert_no_difference 'News.count' do
      post admin_news_index_path, params: { news: { title:  "test", message: "test" }}
      follow_redirect!
      assert_template root_path
    end
    # newsを削除する
    assert_difference 'News.count', -1 do
      delete admin_news_path(@news)
      follow_redirect!
      assert_template root_path
    end
    get new_admin_news_path
    assert_template 'admin/news/new'
    assert_difference 'News.count', 1 do
      post admin_news_index_path, params: { news: { title:  "test", message: "test" }}
      follow_redirect!
      assert_template root_path
    end
  end
end
