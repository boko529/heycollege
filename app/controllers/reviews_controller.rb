class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def create
    @review = current_user.reviews.new(review_params)
    if @review.save
      flash[:success] = "レビューを投稿しました"
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def review_params
      params.require(:review).permit(:title, :content, :lecture_id)
    end

end
