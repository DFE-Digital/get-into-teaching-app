module StaticPageCache
  extend ActiveSupport::Concern

private

  def cache_static_page
    config = Rails.application.config.x.static_pages

    if config.etag && !config.disable_caching && \
        Rails.application.config.action_controller.perform_caching

      @cacheable_static_page = true
      expires_in config.expires_in, public: true

      if stale?(etag: config.etag, last_modified: config.last_modified, public: true)
        yield
      end
    else
      yield
    end
  end
end
