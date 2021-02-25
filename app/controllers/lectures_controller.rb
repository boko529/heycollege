class LecturesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show, :new, :edit, :upgrade, :destroy]
  before_action :baria_user, only: [:edit, :destroy, :update]
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
    # 参考になる順で表示
    reviews = @lecture.reviews.includes(:helpfuls).sort{ |a,b| b.helpfuls.size <=> a.helpfuls.size }
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
    @lecture = current_user.lectures.build(lecture_params)
    @teacher = Teacher.find_by(name: @lecture.teacher_name)

    if @teacher
      @lecture.teacher_id = @teacher.id
      if @lecture.save
        flash[:success] = "講義ページを作成しました"
        redirect_to @lecture
      else
        render 'new'
      end
    else
      @teacher = current_user.teachers.build(name: @lecture.teacher_name)
      @a = true # @teacher.saveが成功すればtrueのまま.
      unless @teacher.save
        @a = false # ここから直接render 'new' はできない.
      end
      @lecture.teacher_id = @teacher.id
      if @lecture.save && @a == true
        flash[:success] = "講義ページ&先生ページを作成しました"
        redirect_to @lecture
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
    if @lecture.update(lecture_params)
      @teacher = Teacher.find_by(name: @lecture.teacher_name)
      if @teacher
        @lecture.teacher_id = @teacher.id
        if @lecture.save
          flash[:success] = "講義情報は更新されました！"
          redirect_to @lecture
        else
          render 'edit'
        end
      else 
        @teacher = current_user.teachers.build(name: @lecture.teacher_name)
        if @teacher.save
          @lecture.teacher_id = @teacher.id
          @lecture.teacher_name = @teacher.name
          if @lecture.save
            flash[:success] = "講義情報は更新されました！&先生ページを作成しました!"
            redirect_to @lecture
          else
            render 'edit'
          end
        else
          render 'edit'
        end
      end
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
      params.require(:lecture).permit(:name, :teacher_name)
    end

    def baria_user
      unless Lecture.find_by(id: params[:id]).user_id == current_user.id
        flash[:danger] = "権限がありません"
        redirect_to lecture_path
      end
    end

end