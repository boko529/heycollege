require "test_helper"

class ZoomTest < ActiveSupport::TestCase
  def setup
    @university = universities(:one)
    @user = users(:user1)
    @zoom = @user.zooms.build(title: "test",join_url: "https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09", user_id: @user.id, start_time:Time.now+100, end_time:Time.now+200, count: 1, university_id: @university.id)
  end

  test "zoom should be valid" do
    assert @zoom.valid?
  end

  test "zoom URL validation should accept valid URL" do
    valid_URLs = %w[https://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09 http://us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09 https://zoom.us/j/93195579294 http://zoom.us/j/93195579294]
    valid_URLs.each do |valid_URL|
      @zoom.join_url = valid_URL
      assert @zoom.valid?, "#{valid_URL.inspect} should be valid"
    end
  end

  test "zoom URL validation should reject invalid addresses" do
    invalid_URLs = %w[https://us04web,zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09 https://us04web.zoom.us//73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09 https://us04web.zoom/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09 https;//us04web.zoom.us/j/73988743960?pwd=cWRNMzNGcUwrWFlyVFg3ZjlRUjF3Zz09 https://zom.us/j/93195579294 https://zoom.us/j https://zoom.us//93195579294 https://zoom/j/93195579294 https://zoom,us/j/93195579294 https;//zoom.us/j/93195579294]
    invalid_URLs.each do |invalid_URL|
      @zoom.join_url = invalid_URL
      assert_not @zoom.valid?, "#{invalid_URL.inspect} should be invalid"
    end
  end

  test "zoom start time should be valid" do
    @zoom.start_time = nil
    assert_not @zoom.valid?
  end

  test "zoom end time should be valid" do
    @zoom.end_time = nil
    assert_not @zoom.valid?
  end

  test "zoom join url should be valid" do
    @zoom.join_url = " "
    assert_not @zoom.valid?
  end

  test "zoom title should be valid" do
    @zoom.title= " "
    assert_not @zoom.valid?
  end

  test "university_id should be present" do
    @zoom.university_id= nil
    assert_not @zoom.valid?
  end
end