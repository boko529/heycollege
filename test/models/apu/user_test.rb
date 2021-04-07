require "test_helper"

class Apu::UserTest < ActiveSupport::TestCase
  def setup
    @university = universities(:one)
    @user1 = User.new(name: "ExampleUser", email: "user@apu.ac.jp",password: "foobar",password_confirmation: "foobar", agreement: true, type: Apu::User, confirmed_at: Time.now, university_id: @university.id)
  end

  test "valid apu_user" do
    assert @user1.valid?
  end

  test "invalid email" do
    invalid_emails = ["Example@gmail.com", "Example@edu.osakafu-u.ac.jp"]
    invalid_emails.each do |email|
      @user1.email = email
      assert_not @user1.valid?
    end
  end
end
