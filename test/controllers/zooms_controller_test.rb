require "test_helper"

class ZoomsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @zoom = zooms(:zoom1)
    @other_zoom = zooms(:zoom2)
  end
  
  ##create
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

  ##destroy
  test "zoom destroy" do
    login_as(@user, scope: :user)
    assert_difference 'Zoom.count', -1 do
      delete zoom_path(@zoom.id)
    end
    assert_not flash.empty?
    follow_redirect!
    assert_template "zooms/index"
  end
  
  test "zoom destroy not login" do
    assert_no_difference 'Zoom.count' do
      delete zoom_path(@zoom.id)
    end
    assert_template nil
  end

  test "others zoom don't destroy" do
    login_as(@user, scope: :user)
    assert_no_difference 'Zoom.count' do
      delete zoom_path(@other_zoom.id)
    end
    assert_template nil
  end

  time = Time.now.floor
  #edit,update
  test "zoom update" do
    login_as(@user, scope: :user)
    get edit_zoom_path(@zoom.id)
    assert_template "zooms/edit"
    patch zoom_path(@zoom.id), params: { zoom: { title: "testtest", description: "testtest",join_url: "https://zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", start_time: time+100, end_time: time+200}}
    assert_redirected_to @zoom
    @zoom.reload
    assert_equal "testtest", @zoom.title
    assert_equal "testtest", @zoom.description
    assert_equal "https://zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", @zoom.join_url
    assert_equal time+100, @zoom.start_time
    assert_equal time+200, @zoom.end_time
  end

  test "zoom update not login" do
    patch zoom_path(@zoom.id), params: { zoom: { title: "testtest", description: "testtest",join_url: "https://zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", start_time: time+100, end_time: time+200}}
    assert_template nil
  end

  test "other zoom don't update" do
    login_as(@user, scope: :user)
    patch zoom_path(@other_zoom.id), params: { zoom: { title: "testtest", description: "testtest",join_url: "https://zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", start_time: time+100, end_time: time+200}}
    assert_template nil
  end
end
