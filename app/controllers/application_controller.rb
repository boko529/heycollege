class ApplicationController < ActionController::Base
  before_action :set_search

  def set_search
    @q = Lecture.ransack(params[:q])
    @lectures = @q.result.page(params[:page])
  end
end
