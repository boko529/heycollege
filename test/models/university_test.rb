require "test_helper"

class UniversityTest < ActiveSupport::TestCase
  def setup
    @university = University.new(name_ja: "立命館アジア太平洋大学")
  end

  test "should be valid" do
    assert @university.valid?
  end

  test "name_ja should be present" do
    @university.name_ja = " "
    assert_not @university.valid?
  end
end
