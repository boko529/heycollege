class HelpfulsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_review, only: [:create]
  before_action :set_lecture, only: [:create]
  before_action :not_helpful_me, only: [:create]
  
  def create
    helpful = Helpful.create(user_id: current_user.id, review_id: params[:review_id])
    helpful.save
    review = Review.find(params[:review_id])
    # 通知を発行
    helpful.create_notification_helpful!(current_user)
  end

  private
    def set_review
      @review = Review.find_by(id: params[:review_id])
    end

    def set_lecture
      @lecture = Lecture.find_by(id: params[:lecture_id])
    end

    def not_helpful_me
      if Review.find_by(id: params[:review_id]).user_id == current_user.id
        flash[:danger] = "自分のレビューに役に立ったはできません。"
        redirect_to lecture_path(@lecture)
      end
    end
end
