class LecturesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :upgrade, :destroy]
  before_action :baria_user, only: [:edit, :destroy, :update]
  before_action :set_teacher_name, only: [:create, :update]
  before_action :set_past_teacher, only: [:update, :destroy]
  after_action :delete_teacher_automatically, only: [:update, :destroy]

  def index
    @q = Lecture.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @lectures = @q.result.left_joins(:reviews).distinct.sort_by do |lecture|
      reviews = lecture.reviews
      if reviews.present?
        reviews.map(&:score).sum / reviews.size
      else
        0
      end
    end.reverse
    @lectures = Kaminari.paginate_array(@lectures).page(params[:page]).per(20)
  end

  def show
    @lecture = Lecture.find(params[:id])
    # 参考になる順で表示 + 詳細が書かれているものに限定
    reviews = @lecture.reviews.where.not(content: "").includes(:helpfuls).sort{ |a,b| b.helpfuls.size <=> a.helpfuls.size }
    @reviews = Kaminari.paginate_array(reviews).page(params[:page]).per(7)

    # 最新順で表示
    # @reviews = @lecture.reviews.order(created_at: :desc).page(params[:page]).per(7)
    @review = current_user.reviews.new

    @teacher = @lecture.teacher
  end

  def new
    @lecture = current_user.lectures.build
  end
  
  def create
    @lecture = current_user.lectures.build
    if @teacher = Teacher.find_by(name: @teacher_name)
      @lecture = current_user.lectures.build(name: lecture_params[:name], teacher_id: @teacher.id)
      if @lecture.save
        flash[:success] = "講義ページを作成しました"
        redirect_to @lecture
      else
        render 'new'
      end
    else
      @teacher = current_user.teachers.build(name: @teacher_name)
      if @teacher.save
        @lecture = current_user.lectures.build(name: lecture_params[:name], teacher_id: @teacher.id)
        if @lecture.save
          flash[:success] = "講義ページ&先生ページを作成しました"
          redirect_to @lecture
        else
          render 'new'
          @teacher.destroy
        end
      else
        render 'new'
      end
    end
  end

  def edit
    @lecture = Lecture.find(params[:id])
  end

  def update
    @lecture = Lecture.find(params[:id])
    if @teacher = Teacher.find_by(name: @teacher_name)
      if @lecture.update(name: lecture_params[:name], teacher_id: @teacher.id)
        flash[:success] = "講義情報は更新されました！"
        redirect_to @lecture
      else
        render 'edit'
      end
    else 
      @teacher = current_user.teachers.build(name: @teacher_name)
      if @teacher.save
        if @lecture.update(name: lecture_params[:name], teacher_id: @teacher.id)
          flash[:success] = "講義情報は更新されました！&先生ページを作成しました!"
          redirect_to @lecture
        else
          render 'edit'
          @teacher.destroy
        end
      else
        render 'edit'
      end
    end
  end

  def destroy
    Lecture.find(params[:id]).destroy
    flash[:success] = "講義を削除しました"
    redirect_to lectures_url
  end

  private
    def lecture_params
      params.require(:lecture).permit(:name, :last_name, :first_name)
    end

    def baria_user
      unless Lecture.find_by(id: params[:id]).user_id == current_user.id
        flash[:danger] = "権限がありません"
        redirect_to lecture_path
      end
    end

    def set_teacher_name
      if lecture_params[:last_name] && lecture_params[:first_name]
        @teacher_name = lecture_params[:last_name] + " " + lecture_params[:first_name]
      else
        @teacher_name = ""
      end
    end

    def set_past_teacher
      @lecture = Lecture.find(params[:id])
      @past_teacher = @lecture.teacher
    end

    def delete_teacher_automatically
      if @past_teacher.lectures.count == 0
        @past_teacher.destroy
      end
    end
end