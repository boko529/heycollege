require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user1 = User.new(name: "ExampleUser", email: "user@apu.ac.jp",password: "foobar",password_confirmation: "foobar", agreement: true, type: Apu::User)
    # @gmail_user = User.new(name: "GmailUser", email: "user@gmil.com",password: "foobar",password_confirmation: "foobar", agreement: true, type: Apu::User)
    # @teacher = teachers(:teacher1)
  end

  test "should be valid" do
    assert @user1.valid?
  end

  
end
