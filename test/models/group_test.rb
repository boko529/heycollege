require "test_helper"

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Group.new(name: "ExampleGroup")
  end

  test "should be valid" do
    assert @group.valid?
  end

  test "name should be present" do
    @group.name = "   "
    assert_not @group.valid?
  end

  test "name should be unique" do
    duplicate_group = @group.dup
    @group.save
    assert_not duplicate_group.valid?
  end

  test "twitter name should not be too long" do
    @group.twitter_name = "a" * 31
    assert_not @group.valid?
  end

  test "instagram name should not be too long" do
    @group.instagram_name = "a" * 31
    assert_not @group.valid?
  end

  # 画像投稿系のtest(参考サイト： https://qiita.com/kazasiki/items/da902eefbf76d1a7aa28)細かいバリデーションについてなどは省略します。
  test 'upload profile_image' do
    file_dir = Rails.root.join('test/fixtures/files/')
    File.open(file_dir.join('test_image.png')) do |image|
      @group.profile_image = image
      @group.save!
    end
  end

  # 画像投稿系のtest(参考サイト： https://qiita.com/kazasiki/items/da902eefbf76d1a7aa28)細かいバリデーションについてなどは省略します。
  test 'upload header_image' do
    file_dir = Rails.root.join('test/fixtures/files/')
    File.open(file_dir.join('test_image.png')) do |image|
      @group.header_image = image
      @group.save!
    end
  end
end
