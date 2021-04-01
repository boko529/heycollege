class StaticPagesController < ApplicationController
  def home
      #講義ランキング処理
      # もともとのコード
      # lectures = Lecture.includes(:reviews).sort_by do |lecture|
      #   if lecture.reviews.present?
      #     lecture.average_score
      #   else
      #     0
      #   end
      # end.reverse  ids.map{ |id| Article.find(id) }
      
      # redis用のコード
      lectures = REDIS.zrevrangebyscore( "rank/lectures/#{current_user.university_id}", "+inf", "-inf" ).map{ |id| Lecture.find(id) }
      @lectures = Kaminari.paginate_array(lectures).page(params[:lectures_page]).per(20)

      #先生ランキング処理
      # もともとのコード
      # teachers = Teacher.includes(lectures: :reviews).sort_by do |teacher|
      #   if teacher.lectures.present?
      #     teacher.average_score
      #   else
      #     0
      #   end
      # end.reverse

      # redis用のコード
      teachers = REDIS.zrevrangebyscore( "rank/teachers/#{current_user.university_id}", "+inf", "-inf" ).map{ |id| Teacher.find(id) }
      @teachers = Kaminari.paginate_array(teachers).page(params[:teachers_page]).per(20)
      
      #ユーザーランキング処理(管理者、退会者は除く,非承認者)
      # もともとのコード
      # users = User.where(admin: false, is_deleted: false).where.not(confirmed_at: nil).includes(:user_point_history).sort_by  do |user|
      #   total_amount = 0
      #   if user.user_point_history.present?
      #     user.user_point_history.all.each do |user_point_history|
      #       if user_point_history.created_at.month == Time.now.month
      #         total_amount += user_point_history.amount
      #       end
      #     end
      #   end
      #   total_amount
      # end.reverse

      # redis用のコード
      users = REDIS.zrevrangebyscore( "rank/users/#{current_user.university_id}", "+inf", "-inf" ).map{ |id| User.find(id) }
      @users = Kaminari.paginate_array(users).page(params[:users_page]).per(20)

      #最新のニュースを表示
      @news = News.where(university_id: current_user.university_id) if current_user
    end
end
