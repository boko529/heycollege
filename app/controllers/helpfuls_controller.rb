class HelpfulsController < ApplicationController
  before_action :set_review, only: [:create, :destroy]
  before_action :set_lecture, only: [:create, :destroy]
  def create
    helpful = current_user.helpfuls.build(review_id: params[:review_id])
    helpful.save
  end

  def destroy
    helpful = Helpful.find_by(user_id: current_user.id, review_id: params[:review_id] )
    helpful.destroy
  end

  private
    def set_review
      @review = Review.find_by(id: params[:review_id])
    end
    def set_lecture
      @lecture = Lecture.find_by(id: params[:lecture_id])
    end
end
