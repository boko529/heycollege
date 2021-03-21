class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :baria_user, only: [:destroy]

  def create
    @lecture = Lecture.find(params[:lecture_id])
    # 既にその講義にレビューを書いているか確認
    unless @lecture.review?(current_user)
      @review = current_user.reviews.new(review_params)
      if @review.save
        flash[:success] = t('.post')
        # 自分が作ったレビューをidで指定して表示
        redirect_to "/lectures/#{@lecture.id}/#review-#{@review.id}"
      else
        flash[:danger] = t('.post-failed')
        redirect_back(fallback_location: root_path)
        # render 'lectures/show'
      end
    else
      flash[:danger] = t('.one-review')
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @lecture = Lecture.find(params[:lecture_id])
    @review = Review.find(params[:id]).destroy
    flash[:success] = t('.delete-review')
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
