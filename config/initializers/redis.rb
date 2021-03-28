require 'redis'
uri = URI.parse('localhost:6379')
if Rails.env.production? #本番環境(heroku)
    REDIS = Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
else # 開発環境
    REDIS = Redis.new(host: uri.host, port: uri.port) 
end