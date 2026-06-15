require "uri_checker"

GetIntoTeachingApiClient.configure do |config|
  config.host = "localhost:4000"
  config.access_token = "RNPLJKf-Z9HVGF7fo8sz"

  config.server_index = nil
  config.scheme = "http"
  config.cache_store = Rails.application.config.x.api_client_cache_store

  config.circuit_breaker = {
    enabled: true,
    threshold: 5,
    timeout: 5.minutes,
  }
end
