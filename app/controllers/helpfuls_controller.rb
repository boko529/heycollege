class HelpfulsController < ApplicationController
  def create
    helpful = current_user.helpfuls.build(review_id: params[:review_id])
    helpful.save
    redirect_to lectures_path
  end

  def destroy
    helpful = Helpful.find_by(review_id: params[:review_id], user_id: current_user.id)
    helpful.destroy
    redirect_to lectures_path
  end
end
