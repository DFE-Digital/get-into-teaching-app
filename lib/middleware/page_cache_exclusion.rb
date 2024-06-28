module Middleware
  class PageCacheExclusion
    def initialize(app)
      @app = app
    end

    def call(env)
      rack_response = @app.call(env)
      response_body = rack_response[2]

      if dynamic_page?(response_body)
        Rack::PageCaching::Cache.delete(cache_path(rack_response, env))
      end

      rack_response
    end

  private

    def cache_path(rack_response, env)
      response = Rack::PageCaching::Response.new(rack_response, env)

      Rack::PageCaching::Cache.new(response).page_cache_path
    end

    def dynamic_page?(response_body)
      extract_body(response_body)&.match(/method="(post|put|patch)"/i)
    end

    def extract_body(response_body)
      # If the response goes through our HtmlResponseTransformer it
      # will be an Array, otherwise an instance of ActionDispatch::Response::RackBody.
      response_body.is_a?(ActionDispatch::Response::RackBody) ? response_body.body : response_body.first
    end
  end
end
