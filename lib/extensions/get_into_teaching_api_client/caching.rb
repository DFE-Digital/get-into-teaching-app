module Extensions
  module GetIntoTeachingApiClient
    module Caching
      MAX_AGE = 10.minutes.to_i
      MAX_RETRIES = 1
      RETRY_EXCEPTIONS = [::Faraday::ConnectionFailed].freeze
      RETRY_OPTIONS = {
        max: MAX_RETRIES,
        methods: %i[get],
        exceptions:
          ::Faraday::Request::Retry::DEFAULT_EXCEPTIONS + RETRY_EXCEPTIONS,
      }.freeze

      def faraday
        Faraday.new do |f|
          f.use :http_cache, store: Rails.cache, shared_cache: false
          f.use Faraday::OverrideCacheControl, cache_control: "private, max-age=#{MAX_AGE}"
          f.response :encoding
          f.adapter Faraday.default_adapter
          f.request :oauth2, config.api_key["Authorization"], token_type: :bearer
          f.request :retry, RETRY_OPTIONS
        end
      end

      def call_api(http_method, path, opts = {})
        original_request = build_request(http_method, path, opts)

        response = faraday.public_send(http_method.downcase) do |req|
          req.url(original_request.url)
          req.params = original_request.options[:params]
          req.body = original_request.options[:body]
          req.headers["Content-Type"] = "application/json"
        end

        unless response.success?
          raise ::GetIntoTeachingApiClient::ApiError.new(
            code: response.status,
            response_headers: response.headers,
            response_body: response.body,
          )
        end

        if opts[:return_type]
          data = deserialize(response, opts[:return_type])
        end

        [data, response.status, response.headers]
      end
    end

    class Faraday::OverrideCacheControl < Faraday::Middleware
      def initialize(app, options = {})
        super(app)
        @cache_control = options[:cache_control]
      end

      def call(env)
        response = @app.call(env)
        cachable = response.headers["ETag"].present?
        response.headers["Cache-Control"] = @cache_control if cachable
        response
      end
    end
  end
end
