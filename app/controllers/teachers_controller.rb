class TeachersController < ApplicationController
    include UsersHelper
    before_action :authenticate_user!, only: [:create, :show, :new, :edit, :update, :destroy]
    before_action :baria_user, only: [:edit, :destroy, :update]
    before_action :name_set, only: [:create, :update]
    def index
        @p = Teacher.ransack(params[:p])
        @p.sorts = 'updated_at desc' if @p.sorts.empty?
        @teachers = Teacher.all.sort_by do |teacher|
          if teacher.average_score == "不明" 
            0
          else
            teacher.average_score
          end
        end.reverse
        @teachers = Kaminari.paginate_array(@teachers).page(params[:page]).per(20)
    end
    
    def show
      @teacher = Teacher.find(params[:id])
    end
    
    private
      def teacher_params
        params.require(:teacher).permit(:first_name, :last_name)
      end
    
      def baria_user
        unless Teacher.find_by(id: params[:id]).user_id == current_user.id
          flash[:danger] = "権限がありません"
          redirect_to teacher_path
        end
      end

      def name_set
        if teacher_params[:last_name] && teacher_params[:first_name]
          @name = teacher_params[:last_name] + " " + teacher_params[:first_name]
        else
          @name = ""
        end
      end
end
