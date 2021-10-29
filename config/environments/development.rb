Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  # config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  # config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  # config.active_record.verbose_query_logs = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.x.git_api_endpoint = \
    "https://get-into-teaching-api-dev.london.cloudapps.digital/api"
  config.x.google_maps_key = ENV["GOOGLE_MAPS_KEY"].presence || \
    Rails.application.credentials.google_maps_key.presence
  config.x.enable_beta_redirects = false

  config.x.http_auth = ENV["BASIC_AUTH_CREDENTIALS"].presence || \
    Rails.application.credentials.basic_auth_credentials.presence

  config.x.api_client_cache_store = ActiveSupport::Cache::MemoryStore.new

  config.x.basic_auth = ENV["BASIC_AUTH"]

  config.x.structured_data.blog_posting = true
  config.x.structured_data.web_site = true
  config.x.structured_data.organization = true
  config.x.structured_data.breadcrumb_list = true
  config.x.structured_data.event = true
  config.x.structured_data.how_to = true

  config.x.legacy_tracking_pixels = false

  config.x.covid_banner = false
end
