class TeachersController < ApplicationController
    include UsersHelper
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

      def name_set
        if teacher_params[:last_name] && teacher_params[:first_name]
          @name = teacher_params[:last_name] + " " + teacher_params[:first_name]
        else
          @name = ""
        end
      end
end
