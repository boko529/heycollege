class TeachersController < ApplicationController
    include UsersHelper
    before_action :authenticate_user!, only: [:create, :show, :new, :edit, :upgrade, :destroy]
    before_action :baria_user, only: [:edit, :destroy, :update]
    def index
        @p = Teacher.ransack(params[:q])
        @p.sorts = 'updated_at desc' if @p.sorts.empty?
        @teachers = @p.result.page(params[:page]).per(25)
    end
    
    def show
      @teacher = Teacher.find(params[:id])
    end

    def new
      @teacher = current_user.teachers.build
    end
      
    def create
      @teacher = current_user.teachers.build(teacher_params)
      if @teacher.save
        flash[:success] = "先生ページを作成しました"
        redirect_to @teacher
      else
        render 'new'
      end
    end
    
    def edit
      @teacher = Teacher.find(params[:id])
    end
    
    def update
      @teacher = Teacher.find(params[:id])
      if @teacher.update(teacher_params)
        flash[:success] = "先生情報は更新されました！"
        redirect_to @teacher
      else
        render 'edit'
      end
    end
    
    def destroy
      Teacher.find(params[:id]).destroy
      flash[:success] = "先生を削除しました"
      redirect_to teachers_url
    end
    
    private
      def teacher_params
        params.require(:teacher).permit(:name)
      end
    
      def baria_user
        unless Teacher.find_by(id: params[:id]).user_id == current_user.id
          flash[:danger] = "権限がありません"
          redirect_to teacher_path
        end
      end
end
