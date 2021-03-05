require "test_helper"

class UserGroupRelationsControllerTest < ActionDispatch::IntegrationTest
  test "create should require logged-in user" do
    assert_no_difference 'UserGroupRelation.count' do
      post user_group_relations_path
    end
  end

  # test "destroy should require logged-in user" do
  #   assert_no_difference 'UserGroupRelation.count' do
  #     delete user_group_relations_path(user_group_relations(:one))
  #   end
  # end
end