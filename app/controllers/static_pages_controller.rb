class StaticPagesController < ApplicationController
  def home
    @lectures = Lecture.left_joins(:reviews).distinct.sort_by do |lecture|
      reviews = lecture.reviews
      if reviews.present?
        reviews.map(&:score).sum / reviews.size
      else
        0
      end
    end.reverse
    @lectures = Kaminari.paginate_array(@lectures).page(params[:page]).per(20)
    @news = News.all

    @teachers = Teacher.all do |teacher|
      if teacher.average_score == "不明" 
        0
      else
        teacher.average_score
      end
    end
    @teachers = Kaminari.paginate_array(@teachers).page(params[:page]).per(20)
  end
end
