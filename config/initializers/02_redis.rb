if ENV["REDIS_URL"].blank? && Rails.application.config.x.vcap_services.present?
  redis_url = Rails.application.config.x.vcap_services.dig \
    "redis", 0, "credentials", "uri"

  ENV["REDIS_URL"] = redis_url if redis_url.present?
end

REDIS = Redis.new(url: ENV["REDIS_URL"] || "")

if ENV["REDIS_URL"].present? && REDIS.ping != "PONG"
  raise "Cannot connect to Redis"
end
