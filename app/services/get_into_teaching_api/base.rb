module GetIntoTeachingApi
  class Base
    MAX_RETRIES = 2
    TIMEOUT_SECS = 10
    RETRY_EXCEPTIONS = [::Faraday::ConnectionFailed].freeze
    RETRY_OPTIONS = {
      max: MAX_RETRIES,
      methods: %i{get},
      exceptions:
        ::Faraday::Request::Retry::DEFAULT_EXCEPTIONS + RETRY_EXCEPTIONS
    }.freeze

    def initialize(token:, host:, basepath: nil)
      @token = token.presence || raise(MissingApiToken)
      @host = host.presence || raise(MissingHost)
      @basepath = basepath.presence
    end

    class MissingApiToken < RuntimeError; end
    class MissingHost < RuntimeError; end

  private

    def endpoint
      URI::HTTPS.build \
        host: @host,
        path: [@basepath, '/', path].compact.join
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
      @response ||= faraday.get(endpoint)
    end

    def data
      response.body
    end
  end
end
