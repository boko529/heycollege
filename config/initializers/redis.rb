require 'redis'
uri = URI.parse('localhost:6379')
REDIS = Redis.new(host: uri.host, port: uri.port)