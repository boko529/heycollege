require "test_helper"

class SlideContentTest < ActiveSupport::TestCase
  def setup
    @university = universities(:one)
    @slide = @university.slide_contents.build(slide_image: "test", link: "https://www.heycollege.jp")
  end

  test "slide content should be present" do
    @slide.slide_image = nil
    assert_not @slide.valid?
  end

  # 画像投稿系のtest(参考サイト： https://qiita.com/kazasiki/items/da902eefbf76d1a7aa28)細かいバリデーションについてなどは省略します。
  test 'upload image' do
    file_dir = Rails.root.join('test/fixtures/files/')
    File.open(file_dir.join('test_image.png')) do |image|
      @slide.slide_image = image
      assert @slide.valid?
    end
  end
end
