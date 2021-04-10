# 管理者用.ランキングを更新できます.
class RedisController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin

  def show
  end

  def ranking_update
    REDIS.flushall # redisを一旦リセット
    #ランキング更新, 大学ごとにデータ保存分けてる.
    (1..2).each{|univ_id| # 1:apu, 2:opu 新たに大学が増えたときは繰り返し増やす.
      Lecture.where(university_id: univ_id).includes(:reviews).map{ |lecture| REDIS.zadd "rank/lectures/#{univ_id}", lecture.average_score, lecture.id  unless lecture.average_score == "不明" }
      Teacher.where(university_id: univ_id).includes(:lectures).map{ |teacher| REDIS.zadd "rank/teachers/#{univ_id}", teacher.average_score, teacher.id  unless teacher.average_score == "不明" }
      #ユーザーランキング処理(管理者、退会者は除く,非承認者)
      # ↓なぜかこの書き方（map）にしたらいけた. ちょい見栄え悪いかもやけど許して.
      User.where(admin: false, is_deleted: false, university_id: univ_id).where.not(confirmed_at: nil).includes(:user_point).map{ |user|
        # total_amount = 0
        # if user.user_point_history.present?
        #   user.user_point_history.all.each do |user_point_history|
        #     if user_point_history.created_at.month == Time.now.month
        #       total_amount += user_point_history.amount
        #     end
        #   end
        # end
        # 同率のとき、レビュー数が高い順にソート→小数部分でレビュー数を表す.
        REDIS.zadd "rank/users/#{univ_id}", user.user_point.current_point + 0.001 * user.reviews.count, user.id
      }
    }
    flash[:success] = "ランキングを更新しました"
    render 'show'
  end

  def reset_ranking
    REDIS.flushall # redisを一旦リセット
    flash[:success] = "ランキングをリセットしました"
    render 'show'
  end

  def lecture_ranking_update
    (1..2).each{|univ_id| # 1:apu, 2:opu 新たに大学が増えたときは繰り返し増やす.
      Lecture.where(university_id: univ_id).includes(:reviews).map{ |lecture| REDIS.zadd "rank/lectures/#{univ_id}", lecture.average_score, lecture.id  unless lecture.average_score == "不明" }
    }
    flash[:success] = "講義ランキングを更新しました"
    render 'show'
  end

  def teacher_ranking_update
    (1..2).each{|univ_id| # 1:apu, 2:opu 新たに大学が増えたときは繰り返し増やす.
      Teacher.where(university_id: univ_id).includes(:lectures).map{ |teacher| REDIS.zadd "rank/teachers/#{univ_id}", teacher.average_score, teacher.id  unless teacher.average_score == "不明" }
    }
    flash[:success] = "先生ランキングを更新しました"
    render 'show'
  end

  def user_ranking_update
    (1..2).each{|univ_id| # 1:apu, 2:opu 新たに大学が増えたときは繰り返し増やす.
      User.where(admin: false, is_deleted: false, university_id: univ_id).where.not(confirmed_at: nil).includes(:user_point).map{ |user|
        # 同率のとき、レビュー数が高い順にソート→小数部分でレビュー数を表す.
        REDIS.zadd "rank/users/#{univ_id}", user.user_point.current_point + 0.001 * user.reviews.count, user.id
      }
    }
    flash[:success] = "ユーザーランキングを更新しました"
    render 'show'
  end

  private

  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end
  end