class NewsController < ApplicationController
  # before_action :check_university, only: [:show]
  def show
    @news = News.find(params[:id])
  end

  # private
  # def check_university
  #   @news = News.find(params[:id])
  #   if current_user.university_id != @news.university_id
  #     redirect_back(fallback_location: root_path)
  #   end
  # end
end
