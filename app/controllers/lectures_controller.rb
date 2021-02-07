class LecturesController < ApplicationController

  def index
    @lectures = Lecture.all
  end

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

  def edit
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    if @lecture.update(lecture_params)
      flash[:success] = "講義情報は更新されました！"
      redirect_to @lecture
    else
      render 'edit'
    end
  end

  private
    def lecture_params
      params.require(:lecture).permit(:name)
    end
end