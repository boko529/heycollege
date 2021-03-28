require 'redis'
uri = URI.parse('localhost:6379')
REDIS = Redis.new(host: uri.host, port: uri.port) # ここもしかすると環境違えばエラー起こるかも.
# ↓ 本番環境(heroku)ではこっち使ってください.
# REDIS = Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })