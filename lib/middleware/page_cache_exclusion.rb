module Middleware
  class PageCacheExclusion
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if dynamic_page?(body(response))
        Rack::PageCaching::Cache.delete("#{cache_path(env['PATH_INFO'])}.html")
      end

      [status, headers, response]
    end

  private

    def cache_path(path_info)
      # The home page is a special case; the path
      # is not the same as the cache file location.
      path_info == "/" ? "/index" : path_info
    end

    def body(response)
      response.is_a?(ActionDispatch::Response::RackBody) ? response.body : response.first
    end

    def dynamic_page?(body)
      body&.match(/method="(post|put|patch)"/i)
    end
  end
end
