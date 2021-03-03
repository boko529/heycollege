require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @bookmark = bookmarks(:bookmark_1)
  end

  test "login user create bookmark" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture.id)
    assert_template "lectures/show"
    assert_difference 'Bookmark.count' ,1 do
      post lecture_bookmarks_path(@lecture), params: { bookmark: { user_id: @user.id, lecture_id: @lecture.id }}
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_select "div.alert"
  end
  
  test "logout user don't create bookmark" do
    assert_no_difference 'Bookmark.count' do
      post lecture_bookmarks_path(@lecture), params: { bookmark: { user_id: @user.id, lecture_id: @lecture.id }}
    end
    assert_template nil
    assert_not flash.empty?
  end

  test "login user destroy bookmark" do
    login_as(@user, scope: :user)
    get lecture_path(@lecture.id)
    assert_template "lectures/show"
    post lecture_bookmarks_path(@lecture), params: { bookmark: { user_id: @user.id, lecture_id: @lecture.id }}
    assert_difference 'Bookmark.count',-1 do
      delete lecture_bookmarks_path(@lecture) 
    end
    follow_redirect!
    assert_template 'lectures/show'
    assert_select "div.alert"
  end

  test "logout user don't destroy bookmark" do
    assert_no_difference 'Bookmark.count' ,1do
      delete lecture_bookmarks_path(@bookmark.lecture_id)
    end
    assert_template nil
    assert_not flash.empty?
  end

  test "login user watch bookmark" do
    login_as(@user, scope: :user)
    get bookmarks_path
    assert_template 'bookmarks/index'
  end

  test "logout user watch bookmark" do
    get bookmarks_path
    follow_redirect!
    assert_template 'devise/sessions/new'
  end
end
