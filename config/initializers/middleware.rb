require "middleware/html_response_transformer"
require "middleware/page_cache_exclusion"

# Prevent certain pages from being cached
Rails.application.config.middleware.use(Middleware::PageCacheExclusion)

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
