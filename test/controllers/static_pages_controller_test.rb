require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "HeyCollege"
  end

  # いらん
  # test "should get root" do
  #   get root_path
  #   assert_response :success
  #   assert_select "title", "APUクラスレビューサイト | #{@base_title}"
  # end

end
