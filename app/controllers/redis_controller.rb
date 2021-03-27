# このファイルはサンプル用.すぐ消します.
class RedisController < ApplicationController
    def show
      REDIS.set('mykey', 'Hello')
    end

    def ranking_update
      Lecture.all.map{ |lecture| REDIS.zadd "lectures/rank", lecture.average_score, lecture.id }
      Teacher.all.map{ |teacher| REDIS.zadd "teachers/rank", teacher.average_score, teacher.id }
      render 'show'
    end
  end