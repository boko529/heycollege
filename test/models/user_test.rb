require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user1 = User.new(name: "ExampleUser", email: "user@apu.ac.jp",password: "foobar",password_confirmation: "foobar", agreement: true)
    @gmail_user = User.new(name: "GmailUser", email: "user@gmil.com",password: "foobar",password_confirmation: "foobar", agreement: true)
    @teacher = teachers(:teacher1)
  end

  test "should be valid" do
    assert @user1.valid?
  end

  test "name should be present" do
    @user1.name = " "
    assert_not @user1.valid?
  end

  test "email should be present" do
    @user1.email = " "
    assert_not @user1.valid?
  end

  test "email should not be too long" do
    @user1.email = "a" * 246 + "@apu.ac.jp"
    assert_not @user1.valid?
  end

  test "name should not be too long" do
    @user1.name = "a" * 51
    assert_not @user1.valid?
  end

  test "password should be present (nonblank)" do
    @user1.password = @user1.password_confirmation = " " * 6
    assert_not @user1.valid?
  end
  
  test "password should have a minimum length" do
    @user1.password = @user1.password_confirmation = "a" * 5
    assert_not @user1.valid?
  end

  test "associated lectures should be destroyed" do
    @user1.skip_confirmation!
    @user1.save
    @user1.lectures.create!(name_ja:  "日本大学史", teacher_id: @teacher.id)
    assert_difference 'Lecture.count', -1 do
      @user1.destroy
    end
  end

  # test "associated user_point and user_point history should be destroyed" do
  #   @user1.skip_confirmation!
  #   assert @user1.confirmed?
  #   @user1.save
  #   # postで作ってないから自動でポイントが作成されていないので手動で作成。自動で作られるテストはintegrationテストに書いてます
  #   @user_point = @user1.create_user_point(current_point: 10, total_point: 10)
  #   @user1.user_point_history.create!(point_type: 1, amount: 10, user_point_id: @user_point.id)
  #   assert_difference 'User.count', -1 do
  #     assert_difference 'UserPointHistory.count', -1 do
  #       assert_difference 'UserPoint.count', -1 do
  #         @user1.destroy
  #       end
  #     end
  #   end
  # end

  test "sign up user don't have twitter_name" do
    assert_not @user1.twitter_name.present?
  end

  test "sign up user don't have instagram_name" do
    assert_not @user1.instagram_name.present?
  end

  # メアドのバリデーション削除
  # test "gmail user don't sign up" do
  #   assert_not @gmail_user.valid?
  # end

  test "message should not be too long" do
    @user1.message = "a" * 101
    assert_not @user1.valid?
  end

  test "twitter name should not be too long" do
    @user1.twitter_name = "a" * 31
    assert_not @user1.valid?
  end

  test "instagram name should not be too long" do
    @user1.instagram_name = "a" * 31
    assert_not @user1.valid?
   end

  test "is_deleted default false" do
    @user1.save
    assert_not @user1.is_deleted # デフォルトでfalse
  end

  # 画像投稿系のtest(参考サイト： https://qiita.com/kazasiki/items/da902eefbf76d1a7aa28)細かいバリデーションについてなどは省略します。
  test 'upload image' do
    file_dir = Rails.root.join('test/fixtures/files/')
    File.open(file_dir.join('test_image.png')) do |image|
      @user1.image = image
      @user1.save!
    end
  end
end
