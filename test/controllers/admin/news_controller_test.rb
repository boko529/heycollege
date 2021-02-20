require "test_helper"

class Admin::NewsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @admin_user = users(:test_admin)
    @news = news(:news1)
  end

  test "news show in not login" do
    get news_path(@news)
    assert_template "news/show"
  end

  test "news new in not login" do
    get new_admin_news_path
    follow_redirect!
    assert_template 'devise/sessions/new'
    assert_not flash.empty?
  end

  test 'news new in not admin' do
    login_as(@user)
    get new_admin_news_path
    follow_redirect!
    assert_template root_path
  end

  test 'news new in admin' do
    login_as(@admin_user)
    get new_admin_news_path
    assert_template 'admin/news/new'
  end

  #createの成功するテストは統合テストに書いてます

  #newsがすでにある&ログインしていない
  test 'create in not login && news exists' do
    assert_no_difference 'News.count' do
      post admin_news_index_path, params: { news: { title:  "test", message: "test" }}
      follow_redirect!
      assert_template 'devise/sessions/new'
      assert_not flash.empty?
    end
  end

  #newsがすでにある&管理者じゃない
  test 'create in login && news exists' do
    login_as(@user)
    assert_no_difference 'News.count' do
      post admin_news_index_path, params: { news: { title:  "test", message: "test" }}
      follow_redirect!
      assert_template root_path
    end
  end

  #newsがすでにある&管理者のとき
  test 'create in admin && news exists' do
    login_as(@admin_user)
    assert_no_difference 'News.count' do
      post admin_news_index_path, params: { news: { title:  "test", message: "test" }}
      follow_redirect!
      assert_template root_path
    end
  end

  test "news edit in not login" do
    get edit_admin_news_path(@news)
    follow_redirect!
    assert_template 'devise/sessions/new'
    assert_not flash.empty?
  end

  test 'news edit in not admin' do
    login_as(@user)
    get edit_admin_news_path(@news)
    follow_redirect!
    assert_template root_path
  end

  test 'news edit in admin' do
    login_as(@admin_user)
    get edit_admin_news_path(@news)
    assert_template 'admin/news/edit'
  end

  test 'update in not login' do
    patch admin_news_path(@news), params: { news: { title:  "test2", message: "test2" }}
    follow_redirect!
    assert_template 'devise/sessions/new'
    assert_not flash.empty?
    @news.reload
    assert_not_equal "test2", @news.title
  end

  test 'update in not admin' do
    login_as(@user)
    patch admin_news_path(@news), params: { news: { title:  "test2", message: "test2" }}
    follow_redirect!
    assert_template root_path
    @news.reload
    assert_not_equal "test2", @news.title
  end

  test 'valid update in admin' do
    login_as(@admin_user)
    patch admin_news_path(@news), params: { news: { title:  "test2", message: "test2" }}
    follow_redirect!
    assert_template 'news/show'
    @news.reload
    assert_equal "test2", @news.title
  end

  test 'destroy in not login' do
    assert_no_difference 'News.count' do
      delete admin_news_path(@news)
      follow_redirect!
      assert_template 'devise/sessions/new'
      assert_not flash.empty?
    end
  end

  test 'destroy in login' do
    login_as(@user)
    assert_no_difference 'News.count' do
      delete admin_news_path(@news)
      follow_redirect!
      assert_template root_path
    end
  end

  test 'valid destroy in admin' do
    login_as(@admin_user)
    assert_difference 'News.count', -1 do
      delete admin_news_path(@news)
      follow_redirect!
      assert_template root_path
    end
  end
end
