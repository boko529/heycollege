class TeachersController < ApplicationController
    include UsersHelper
    before_action :authenticate_user!, only: :show
    def index
        @p = Teacher.ransack(params[:p])
        @p.sorts = 'updated_at desc' if @p.sorts.empty?
        @teachers = Teacher.includes(lectures: :reviews).sort_by do |teacher|
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
      lectures = @teacher.lectures.includes(:reviews).sort_by do |lecture|  #先生の講義を評価が高い順に
        if lecture.reviews.present?
          lecture.average_score
        else
          0
        end
      end.reverse
      @lectures = Kaminari.paginate_array(lectures).page(params[:lectures_page]).per(5)
      @all_reviews = @teacher.teacher_reviews  #先生に関するレビューを参考になっている順で獲得
      @most_helpful_review = @all_reviews.first if @all_reviews.present? #最も参考になっているレビュー
      @reviews = Kaminari.paginate_array(@all_reviews.drop(1)).page(params[:reviews_page]).per(20) if @all_reviews.present? #先生に関するレビューのうち、もっとも参考になるレビュー以外
    end
    
    private
      # def teacher_params
      #   params.require(:teacher).permit(:first_name, :last_name)
      # end

      # def name_set
      #   if teacher_params[:last_name] && teacher_params[:first_name]
      #     @name = teacher_params[:last_name] + " " + teacher_params[:first_name]
      #   else
      #     @name = ""
      #   end
      # end
end
