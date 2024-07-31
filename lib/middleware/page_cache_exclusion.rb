module Middleware
  class PageCacheExclusion
    def initialize(app)
      @app = app
      @cache = nil
    end

    def call(env)
      status, headers, response = @app.call(env)

      @cache ||= ActionController::Caching::Pages::PageCache.new(
        Rails.application.config.action_controller.page_cache_directory,
        default_static_extension,
        env["action_controller.instance"],
      )

      expire_cached_file_for(env["REQUEST_PATH"]) if dynamic_page?(response)

      [status, headers, response]
    end

  private

    def expire_cached_file_for(path)
      raise "No cache present" if @cache.blank?

      cache_file = cache_file_for(path)
      return if cache_file.blank?
      @cache.expire(cache_file)
    end

    def cache_file_for(path, extension = default_static_extension)
      raise "No cache present" if @cache.blank?

      return if path.blank?
      @cache.send(:cache_file, path, extension)
    end

    def page_cache_directory = Rails.application.config.action_controller.page_cache_directory
    def default_static_extension = Rails.application.config.action_controller.default_static_extension || ".html"

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
