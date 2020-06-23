module GetIntoTeachingApi
  class Base
    MAX_RETRIES = 2
    TIMEOUT_SECS = 10
    RETRY_EXCEPTIONS = [::Faraday::ConnectionFailed].freeze
    RETRY_OPTIONS = {
      max: MAX_RETRIES,
      methods: %i[get],
      exceptions:
        ::Faraday::Request::Retry::DEFAULT_EXCEPTIONS + RETRY_EXCEPTIONS,
    }.freeze

    def initialize(token:, endpoint:)
      @token = token.presence || raise(MissingApiToken)

      raise MissingHost if endpoint.blank?

      @baseuri = URI.parse(endpoint)
    end

    class MissingApiToken < RuntimeError; end
    class MissingHost < RuntimeError; end

  private

    def endpoint
      @baseuri.dup.tap do |uri|
        uri.path = [uri.path, path].join("/")
      end
    end

    def faraday
      Faraday.new do |f|
        f.use Faraday::Response::RaiseError
        f.adapter Faraday.default_adapter
        f.request :oauth2, @token, token_type: :bearer
        f.request :retry, RETRY_OPTIONS
        f.response :json, content_type: /\bjson$/
      end
    end

    def response
      @response ||= faraday.get(endpoint, params, headers)
    end

    def params
      {}
    end

    def headers
      { "Accept" => "application/json" }
    end

    def data
      response.body
    end
  end
end

if Rails.env.development?
  GetIntoTeachingApi::Base.prepend GetIntoTeachingApi::FakeEndpoints
end
