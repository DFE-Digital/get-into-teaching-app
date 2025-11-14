require "uri_checker"

GetIntoTeachingApiClient.configure do |config|
  config.api_key["apiKey"] = ENV["GIT_API_TOKEN"].presence

  endpoint =
    if ENV.key?("GIT_API_PR") && !Rails.env.production?
      # For testing purposes, we can point the website to a GIT API Review instance
      "https://getintoteachingapi-review-#{ENV.fetch('GIT_API_PR').to_i}.test.teacherservices.cloud"
    elsif ENV.key?("GIT_API_ENDPOINT").present?
      ENV.fetch("GIT_API_ENDPOINT")
    else
      Rails.application.config.x.git_api_endpoint.presence
    end

  if endpoint
    parsed = URI.parse(endpoint)

    # if using a non-standard port, include it as part of the host setting
    config.host = parsed.port == 443 ? parsed.hostname : "#{parsed.hostname}:#{parsed.port}"

    # if using a local API for dev, don't verify self-certified ssl certs
    if Rails.env.development? && URIChecker.new(parsed).local_https?
      config.ssl_verify = false
    end

    config.base_path = parsed.path.gsub(%r{\A/api}, "")
  end

  config.server_index = nil
  config.api_key_prefix["apiKey"] = "Bearer"
  config.scheme = "https"
  config.cache_store = Rails.application.config.x.api_client_cache_store

  config.circuit_breaker = {
    enabled: true,
    threshold: 5,
    timeout: 5.minutes,
  }
end
