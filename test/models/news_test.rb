require "test_helper"

class NewsTest < ActiveSupport::TestCase
  def setup
    @university = universities(:one)
    @news = News.new(title: "テスト", message: "テストだよー", university_id: @university.id)
  end

  test "should be valid" do
    assert @news.valid?
  end

  test "title should be present" do
    @news.title = " "
    assert_not @news.valid?
  end
  
  test "title should not be too long" do
    @news.title = "a" * 31
    assert_not @news.valid?
  end
  
  test "message should not be preset" do
    @news.message = " "
    assert @news.valid?
  end
  
  test "message should not be too long" do
    @news.message = "a" * 301
    assert_not @news.valid?
  end

  test "university_id should be present" do
    @news.university_id = nil
    assert_not @news.valid?
  end
end
