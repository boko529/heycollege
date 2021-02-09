class LecturesController < ApplicationController
  def index
    @q = Lecture.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @lectures = @q.result.page(params[:page]).per(25)
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

  def destroy
    Lecture.find(params[:id]).destroy
    flash[:success] = "講義を削除しました"
    redirect_to lectures_url
  end

  private
    def lecture_params
      params.require(:lecture).permit(:name, :language_used, :lecture_type, :lecture_size, :lecture_term)
    end
end