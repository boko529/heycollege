# 管理者用.ランキングを更新できます.
class RedisController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin

  def show
  end

  def ranking_update
    REDIS.flushall
    Lecture.all.map{ |lecture| REDIS.zadd "rank/lectures", lecture.average_score, lecture.id  unless lecture.average_score == "不明" }
    Teacher.all.map{ |teacher| REDIS.zadd "rank/teachers", teacher.average_score, teacher.id  unless teacher.average_score == "不明" }
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
      REDIS.zadd "rank/users", total_amount, user.id
    }
    flash[:success] = "ランキングを更新しました"
    render 'show'
  end

  private

  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
  end