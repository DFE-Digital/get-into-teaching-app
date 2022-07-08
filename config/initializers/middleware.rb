require "middleware/html_response_transformer"

# Page caching middleware
Rails.application.config.middleware.use Rack::PageCaching,
                                        page_cache_directory: Rails.root.join("public/cached_pages"),
                                        gzip: :best_compression,
                                        include_hostname: false

# Transform HTML responses (image optimisations, links)
Rails.application.config.middleware.use(Middleware::HtmlResponseTransformer)

# Only serve from cache when enabled (page caching middleware does
# this check internally)
if Rails.application.config.action_controller.perform_caching
  # Serve the static page cache
  Rails.application.config.action_controller.page_cache_directory = Rails.root.join("public/cached_pages")
  Rails.application.config.middleware.insert_before \
    ActionDispatch::Static, ActionDispatch::Static, File.join(Rails.application.config.root, "public", "cached_pages"),
    headers: { "Cache-Control" => "max-age=#{5.minutes.to_i}, public, immutable" }
end
