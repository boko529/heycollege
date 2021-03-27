# このファイルはサンプル用.すぐ消します.
class RedisController < ApplicationController
    def show
      REDIS.set('mykey', 'Hello')
    end

    def ranking_update
      Lecture.all.map{ |lecture| REDIS.zadd "lectures/rank", lecture.average_score, lecture.id }
      Teacher.all.map{ |teacher| REDIS.zadd "teachers/rank", teacher.average_score, teacher.id }
      #ユーザーランキング処理(管理者、退会者は除く,非承認者)
      # ↓なぜかこの書き方（map）にしたらいけた. ちょい見栄え悪いかもやけど許して.
      User.where(admin: false, is_deleted: false).where.not(confirmed_at: nil).includes(:user_point_history).map{ |user|
        total_amount = 0
        if user.user_point_history.present?
          user.user_point_history.all.each do |user_point_history|
            if user_point_history.created_at.month == Time.now.month
              total_amount += user_point_history.amount
            end
          end
        end
        REDIS.zadd "users/rank/#{Time.now.month.to_s}", total_amount, user.id
      }
      render 'show'
    end
  end