require "test_helper"

class ZoomsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    # @zoom = zooms(:zoom1)
    # @other_zoom = zooms(:zoom2)
  end

  test "zoom create" do
    login_as(@user, scope: :user)
    assert_difference 'Zoom.count', 1 do
      post zooms_path, params: { zoom: { title: "test1", description: "test1", join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09",user_id: @user.id, start_time: Time.now+100, end_time: Time.now+200, count: 1}}
    end
    follow_redirect!
    assert_template 'zooms/show'
  end
  
  test "zoom create without title" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      post zooms_path, params: { zoom: { title: "", description: "test1", join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: @user.id, start_time: Time.now+100, end_time: Time.now+200, count: 1}}
    end
    assert_template 'zooms/new'
  end
  
  test "zoom create without description" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      post zooms_path, params: { zoom: { title: "test1", description: " ", join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: @user.id, start_time: Time.now+100, end_time: Time.now+200, count: 1}}
    end
    assert_template 'zooms/new'
  end

  test "zoom create without join_url" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      post zooms_path, params: { zoom: { title: "test1", description: " ", join_url: "", user_id: @user.id, start_time: Time.now+100, end_time: Time.now+200, count: 1}}
    end
    assert_template 'zooms/new'
  end

  test "zoom create without vaild start and end time" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      post zooms_path, params: { zoom: { title: "test1", description: "test1", join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09",user_id: @user.id, start_time: Time.now+200, end_time: Time.now+100, count: 1}}
    end
    assert_template 'zooms/new'
  end

  test "zoom create without vaild start time" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      post zooms_path, params: { zoom: { title: "test1", description: "test1", join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09",user_id: @user.id, start_time: Time.now-100, end_time: Time.now+100, count: 1}}
    end
    assert_template 'zooms/new'
  end

  test "zoom create without vaild end time" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      post zooms_path, params: { zoom: { title: "test1", description: "test1", join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09",user_id: @user.id, start_time: Time.now+100, end_time: Time.now-100, count: 1}}
    end
    assert_template 'zooms/new'
  end
end
