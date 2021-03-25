# このファイルはサンプル用.すぐ消します.
class RedisController < ApplicationController
    def show
      REDIS.set('mykey', 'Hello')
    end
  end