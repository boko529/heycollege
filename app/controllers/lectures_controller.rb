class LecturesController < ApplicationController

  def show
    @lecture = Lecture.find(params[:id])
  end

  def new
    @lecture = Lecture.new
  end
  
  def create
    @lecture = Lecture.new(lecture_params)
    if @lecture.save
      flash[:success] = "講義ページを作成しました"
      redirect_to @lecture
    else
      render 'new'
    end
  end

  private
    def lecture_params
      params.require(:lecture).permit(:name)
    end
end