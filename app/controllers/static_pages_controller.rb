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

    @teachers = Teacher.left_joins(:lectures).distinct.sort_by do |teacher|
      sum = 0
      count = 0
      lectures = teacher.lectures do |lecture|
        reviews = lecture.reviews
        if reviews.present?
          sum += reviews.map(&:score).sum / reviews.size
          count += 1
        else
          0
        end
      end
      if count == 0
        0
      else
        sum / count
      end
    end.reverse
    @teachers = Kaminari.paginate_array(@teachers).page(params[:page]).per(20)
  end
end
