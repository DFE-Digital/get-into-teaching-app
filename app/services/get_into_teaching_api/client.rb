module GetIntoTeachingApi
  class Client
    include Singleton

    class << self
      delegate :upcoming_events, to: :instance
    end

    def upcoming_events
      UpcomingEvents.new(**api_args).call
    end

    def search_events(**args)
      SearchEvents.new(**api_args.merge(args)).call
    end

  private

    def api_args
      { token: token, endpoint: endpoint }
    end

    def token
      ENV["GIT_API_TOKEN"].presence || \
        Rails.application.credentials.api_token
    end

    def endpoint
      ENV["GIT_API_ENDPOINT"].presence || \
        Rails.application.config.x.api.endpoint.presence
    end
  end
end
