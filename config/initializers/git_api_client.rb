GetIntoTeachingApiClient.configure do |config|
  config.api_key["Authorization"] = \
    ENV["GIT_API_TOKEN"].presence || \
    Rails.application.credentials.git_api_token.presence

  endpoint = ENV["GIT_API_ENDPOINT"].presence || \
    Rails.application.config.x.git_api_endpoint.presence

  if endpoint
    parsed = URI.parse(endpoint)

    config.host = parsed.hostname
    config.base_path = parsed.path.gsub(%r{\A/api}, "")
  end

  config.cache_store = Rails.cache
end
