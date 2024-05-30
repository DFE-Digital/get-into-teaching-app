GetIntoTeachingApiClient.configure do |config|
  config.api_key["apiKey"] = ENV["GIT_API_TOKEN"].presence

  endpoint = ENV["GIT_API_ENDPOINT"].presence || \
    Rails.application.config.x.git_api_endpoint.presence

  if endpoint
    parsed = URI.parse(endpoint)

    # if using a non-standard port, include it as part of the host setting
    config.host = if parsed.port != 443
                    "#{parsed.hostname}:#{parsed.port}"
                  else
                    parsed.hostname
                  end

    # if using a local API for dev, don't verify self-certified ssl certs
    if Rails.env.development? && parsed.hostname == "localhost" && parsed.scheme == "https"
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
