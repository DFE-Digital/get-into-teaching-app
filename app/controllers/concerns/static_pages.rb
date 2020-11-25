module StaticPages
  extend ActiveSupport::Concern

  class InvalidTemplateName < RuntimeError; end

  MISSING_TEMPLATE_EXCEPTIONS = [
    ActionView::MissingTemplate,
    StaticPages::InvalidTemplateName,
    Pages::Frontmatter::MissingTemplate,
  ].freeze

  PAGE_TEMPLATE_FILTER = %r{\A[a-zA-Z0-9][a-zA-Z0-9_\-/]*(\.[a-zA-Z]+)?\z}.freeze

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

  def filtered_page_template(page_param = :page)
    params[page_param].to_s.tap do |page|
      raise InvalidTemplateName if page !~ PAGE_TEMPLATE_FILTER
    end
  end

  def rescue_missing_template
    respond_to do |format|
      format.html do
        render \
          template: "errors/not_found",
          layout: "application",
          status: :not_found
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end
end
