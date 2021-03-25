require "test_helper"

class AutoCreateTest < ActiveSupport::TestCase
  def setup
    @auto_create = AutoCreate.new(name: "APUクラスエクセル")
  end

  test "valid auto_create" do
    assert @auto_create.valid?
  end

  test "name should be present" do
    @auto_create.name = " "
    assert_not @auto_create.valid?
  end
end
