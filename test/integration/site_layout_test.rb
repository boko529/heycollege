require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template "zooms/index"
    assert_select "a[href=?]", root_path
  end
end