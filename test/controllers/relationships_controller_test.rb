require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @other_user = users(:user2)
    @relation = relationships(:relation_1)
  end

  test "login user follow other user" do
    login_as(@user, scope: :user)
    get user_path(@other_user.id)
    assert_template "users/show"
    assert_difference "Notification.count", 1 do
      assert_difference "Relationship.count" ,1 do
        post follow_path(@user.id), params: { relationship: { follower_id: @user.id, followed_id: @other_user.id } }
      end
    end
    follow_redirect!
    assert_template 'users/show'
  end
  
  test "login user unfollow other user" do
    login_as(@user, scope: :user)
    get user_path(@other_user.id)
    assert_template "users/show"
    post follow_path(@user.id), params: { relationship: { follower_id: @user.id, followed_id: @other_user.id } }
    assert_no_difference "Notification.count" do
      assert_difference "Relationship.count" ,-1 do
        post unfollow_path(@user.id), params: { relationship: { follower_id: @user.id, followed_id: @other_user.id } }
      end
    end
    follow_redirect!
    assert_template 'users/show'
  end

  test "logout user don't follow other user" do
    assert_no_difference "Notification.count" do
      assert_no_difference "Relationship.count" do
        post follow_path(@user.id), params: { relationship: { follower_id: @user.id, followed_id: @other_user.id } }
      end
    end
    follow_redirect!
    assert_template 'devise/sessions/new'
  end

  test "logout user don't unfollow other user" do
    assert_no_difference "Notification.count" do
      assert_no_difference "Relationship.count" do
        post unfollow_path(@user.id), params: { relationship: { follower_id: @relation.follower_id, followed_id: @relation.followed_id } }
      end
    end
    follow_redirect!
    assert_template 'devise/sessions/new'
  end
end
