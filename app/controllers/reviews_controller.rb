class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :destroy, :edit, :update]
  before_action :baria_user, only: [:edit, :update, :destroy]
  def show
    @lecture = Lecture.find(params[:lecture_id])
    @review = Review.find(params[:id])
  end

  def create
    @lecture = Lecture.find(params[:lecture_id])
    @review = current_user.reviews.new(review_params)
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_to lecture_review_path(@lecture,@review)
    else
      redirect_back(fallback_location: root_path)
      # render 'lectures/show'
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
