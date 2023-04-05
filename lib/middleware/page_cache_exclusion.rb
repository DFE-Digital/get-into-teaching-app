module Middleware
  class PageCacheExclusion
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if dynamic_page?(body(response))
        Rack::PageCaching::Cache.delete("#{env['PATH_INFO']}.html")
      end

      [status, headers, response]
    end

  private

    def body(response)
      response.is_a?(ActionDispatch::Response::RackBody) ? response.body : response.first
    end

    def dynamic_page?(body)
      body&.match(/method="post"/i)
    end
  end
end
