class LecturesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :upgrade, :destroy]
  before_action :baria_user, only: [:edit, :destroy, :update]
  def index
    @q = Lecture.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @lectures = @q.result.page(params[:page]).per(25)
  end

  def show
    @lecture = Lecture.find(params[:id])
    @reviews = @lecture.reviews.order(created_at: :desc).page(params[:page]).per(7)
    @review = current_user.reviews.new
  end

  def new
    @lecture = current_user.lectures.build
  end
  
  def create
    @lecture = current_user.lectures.build(lecture_params)
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
      params.require(:lecture).permit(:name, :language_used, :lecture_type, :lecture_size, :lecture_term, :group_work)
    end

    def baria_user
      unless Lecture.find_by(id: params[:id]).user_id == current_user.id
        flash[:danger] = "権限がありません"
        redirect_to lecture_path
      end
    end
end