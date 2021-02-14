require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  def setup
    @user = users(:user1)
    @lecture = lectures(:lecture_1)
    @review = reviews(:review1)
    @others_review = reviews(:review2)
  end

  test "review create" do
    login_as(@user, scope: :user)
    assert_difference 'Review.count', 1 do
      post lecture_reviews_path(@lecture), params: { review: { title:  "タイトル", content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, explanation: 2, fairness: 4, recommendation: 3, useful: 2, interesting: 2, difficulty: 2}}
    end
    assert_template nil
    # なぜnil？
    # assert_template 'review/show'
  end

  test "review create in not login" do
    assert_no_difference 'Review.count' do
      post lecture_reviews_path(@lecture), params: { review: { title:  "タイトル", content: "コンテント", user_id: @user.id, lecture_id: @lecture.id, explanation: 2, fairness: 4, recommendation: 3, useful: 2, interesting: 2, difficulty: 3}}
    end
    assert_template nil
    assert_not flash.empty?
  end

  test "review show" do
    login_as(@user, scope: :user)
    get lecture_review_path(@lecture.id, @review.id)
    assert_template "reviews/show"
    assert_not_equal(0, @review.average_score)
  end

  test "review show in not login" do
    get lecture_review_path(@lecture.id, @review.id)
    assert_template nil
  end

  test "review destroy" do
    login_as(@user, scope: :user)
    assert_difference 'Review.count', -1 do
      delete lecture_review_path(@lecture.id, @review.id)
    end
    assert_not flash.empty?
    assert_template nil
    # なぞ
    # assert_template "lecture/show"
  end
  
  test "review destroy not login" do
    assert_no_difference 'Review.count' do
      delete lecture_review_path(@lecture.id, @review.id)
    end
    assert_template nil
    assert_not flash.empty?
  end

  test "others review destory" do
    login_as(@user, scope: :user)
    assert_no_difference 'Review.count' do
      delete lecture_review_path(@lecture.id, @others_review.id)
    end
    assert_not flash.empty?
    assert_template nil
  end
  
  # レビューに編集機能を加える場合
  # test "review edit" do
  #   login_as(@user, scope: :user)
  #   get edit_lecture_review_path(@lecture.id, @review.id)
  #   assert_template 'reviews/edit' 
  # end

  # test "review edit not login" do
  #   get edit_lecture_review_path(@lecture.id, @review.id)
  #   assert_template nil
  # end

  # test "review update" do
  #   login_as(@user, scope: :user)
  #   title = "new_title"
  #   patch lecture_review_path(@lecture.id, @review.id), params: { review: { title: title }}
  #   assert_not flash.empty?
  #   assert_redirected_to lecture_review_path(@lecture.id, @review.id)
  #   @review.reload
  #   assert_equal title,  @review.title
  # end

  # test "review update not login" do
  #   title = "title"
  #   patch lecture_review_path(@lecture.id, @review.id), params: { review: { title: title }}
  #   assert_not flash.empty?
  #   assert_template nil
  #   @review.reload
  #   assert_not_equal title,  @review.title
  # end

  # test "others review edit" do
  #   login_as(@user, scope: :user)
  #   get edit_lecture_review_path(@lecture.id, @others_review.id)
  #   assert_template nil
  #   assert_not flash.empty?
  # end

  # test "others review update" do
  #   login_as(@user, scope: :user)
  #   title = "title"
  #   patch lecture_review_path(@lecture.id, @others_review.id), params: { review: { title: title }}
  #   assert_template nil
  #   @review.reload
  #   assert_not_equal title,  @review.title
  # end

end
