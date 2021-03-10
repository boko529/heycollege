require "test_helper"

class UserGroupRelationsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  def setup
    @user1 = users(:user1) # group1,group2に所属、admin == false
    @user2 = users(:user2) # group1に所属、admin == true
    # @user3 = users(:user3) # group1に所属、admin == false
    @user4 = users(:user4) # group1,group2に所属、admin == true
    # group1  user1,user2(admin),3,4(admin)が所属 adminは2名
    # group2  user1,user4(admin)が所属 adminは1名
    @relation1 = user_group_relations(:one) # user1,group2, admin == false
    @relation2 = user_group_relations(:two) # user2,group1, admin == true
    @relation6 = user_group_relations(:six) # user4,group2, admin == true
  end

  test "create should require logged-in user" do
    assert_no_difference 'UserGroupRelation.count' do
      post user_group_relations_path
    end
    assert_template nil
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'UserGroupRelation.count' do
      delete user_group_relation_path(@relation1)
    end
    assert_template nil
  end
  
  test "destroy should require another admin user(fault)" do
    # group2にuser4以外にadminがいないのでdestroyできない 
    login_as(@user4, scope: :user)
    assert_no_difference 'UserGroupRelation.count' do
      delete user_group_relation_path(@relation6)
    end
    assert_template nil
  end

  test "destroy should require another admin user(success)" do
    # group1にuser2以外にuser4がadminなのでdestroyできる 
    login_as(@user2, scope: :user)
    assert_difference 'UserGroupRelation.count', -1 do
      delete user_group_relation_path(@relation2)
    end
    follow_redirect!
    assert_template 'groups/show'
  end

  test "destroy should require another admin user(self.admin == false)" do
    # group2にuser1以外にuser4がadminなのでdestroyできる (self.admin == falseの場合はdestroy可能)
    login_as(@user1, scope: :user)
    assert_difference 'UserGroupRelation.count', -1 do
      delete user_group_relation_path(@relation1)
    end
    follow_redirect!
    assert_template 'groups/show'
  end

  

end