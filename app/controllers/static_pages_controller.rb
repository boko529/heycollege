class StaticPagesController < ApplicationController
  def home
    #講義ランキング処理
    lectures = Lecture.includes(:reviews).sort_by do |lecture|
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
    
    #ユーザーランキング処理
    users = User.includes(:user_point_history).sort_by  do |user|
      if user.user_point_history.present?
        total_amount = 0
        user.user_point_history.all.each do |user_point_history|
          if user_point_history.created_at.month == Time.now.month
            total_amount += user_point_history.amount
          end
        end
        total_amount
      else
        0
      end
    end.reverse
    @users = Kaminari.paginate_array(users).page(params[:users_page]).per(20)


    #最新のニュースを表示
    @news = News.all
  end
end
