require "test_helper"

class GroupProfileTest < ActiveSupport::TestCase
  def setup
    @profile = group_profiles(:profile1)
  end

  test "should be valid" do
    assert @profile.valid?
  end

  test "blank content should not be valid" do
    @profile.content = '   '
    assert_not @profile.valid?
  end

  test "content should not be too long" do
    @profile.content= "a" * 1001
    assert_not @profile.valid?
  end
end
