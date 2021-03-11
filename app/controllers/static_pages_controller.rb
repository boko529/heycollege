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
    @lectures = Kaminari.paginate_array(lectures).page(params[:page]).per(20)

    #先生ランキング処理
    teachers = Teacher.includes(lectures: :reviews).sort_by do |teacher|
      if teacher.lectures.present?
        teacher.average_score
      else
        0
      end
    end.reverse
    @teachers = Kaminari.paginate_array(teachers).page(params[:page]).per(20)
    
    #ユーザーランキング処理
    users = User.includes(user_point: :user_point_history).sort_by  do |user|
      if user.user_point.present?
      else
        0
      end
    end.reverse
    @users = Kaminari.paginate_array(users).page(params[:page]).per(20)

    #最新のニュースを表示
    @news = News.all
  end
end
