module GetIntoTeachingApi
  class Client
    JSON_CONTENT_TYPES = %w(application/vnd.api+json application/json text/json).freeze

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
        f.response :json, content_type: /\bjson$/
      end
    end

    def response
      resp = faraday.get(endpoint)
      resp.body
    end
  end
end
