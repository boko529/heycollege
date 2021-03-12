class StaticPagesController < ApplicationController
  def home
    #講義ランキング処理
    lectures = Lecture.includes(:teacher, :reviews).sort_by do |lecture|
      if lecture.reviews.present?
        lecture.average_score
      else
        0
      end
    end.reverse
    @lectures = Kaminari.paginate_array(lectures).page(params[:lectures_page]).per(20)

    #先生ランキング処理
    teachers = Teacher.includes(lectures: :reviews).sort_by do |teacher|
      if teacher.lectures.present?
        teacher.average_score
      else
        0
      end
    end.reverse
    @teachers = Kaminari.paginate_array(teachers).page(params[:teachers_page]).per(20)

    #最新のニュースを表示
    @news = News.all
  end
end
