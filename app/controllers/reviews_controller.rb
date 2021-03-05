class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :destroy, :edit, :update]
  before_action :baria_user, only: [:edit, :update, :destroy]
  def show
    @lecture = Lecture.find(params[:lecture_id])
    @review = Review.find(params[:id])
  end

  def create
    @lecture = Lecture.find(params[:lecture_id])
    # 既にその講義にレビューを書いているか確認
    unless @lecture.review?(current_user)
      @review = current_user.reviews.new(review_params)
      if @review.save
        flash[:success] = "レビューを投稿しました"
        # 自分が作ったレビューをidで指定して表示
        redirect_to "/lectures/#{@lecture.id}/#review-#{@review.id}"
      else
        flash[:danger] = "レビューの投稿に失敗しました"
        redirect_back(fallback_location: root_path)
        # render 'lectures/show'
      end
    else
      flash[:danger] = "一つのクラスにレビューは一度のみです"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @lecture = Lecture.find(params[:lecture_id])
    @review = Review.find(params[:id]).destroy
    flash[:success] = "レビューを削除しました"
    redirect_to lecture_path(@lecture)
  end

  private
    def review_params
      params.require(:review).permit(:content, :lecture_id, :user_id, :score)
    end

    def baria_user
      unless Review.find_by(id: params[:id]).user_id == current_user.id
        flash[:danger] = "権限がありません"
        redirect_to lecture_review_path
      end
    end
end
