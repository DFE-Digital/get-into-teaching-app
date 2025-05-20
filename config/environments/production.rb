require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = {
    "Cache-Control" => "max-age=#{1.year.to_i}, public, immutable",
    "Access-Control-Allow-Origin" => ENV["APP_URL"],
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  unless ENV["SKIPSSL"].in? %w[1 true yes]
    # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
    config.force_ssl = true
    config.ssl_options = { redirect: { exclude: ->(request) { request.path.include?("/check") } } }
  end

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [:request_id]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/healthcheck.json"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = :redis_cache_store, { namespace: "GIT" }

  # Replace the default in-process and non-durable queuing backend for Active Job.
  # config.active_job.queue_adapter = :resque

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = { host: "example.com" }

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [:id]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  config.x.git_api_endpoint = \
    "https://getintoteachingapi-production.teacherservices.cloud/api"
  config.x.google_maps_key = ENV["GOOGLE_MAPS_KEY"].presence

  config.x.http_auth = ENV["BASIC_AUTH_CREDENTIALS"].presence

  config.x.api_client_cache_store = ActiveSupport::Cache::RedisCacheStore.new(namespace: "GIT-HTTP")

  config.x.basic_auth = ENV["BASIC_AUTH"]

  # Configure Semantic Logging for production environments
  # This cannot be conditionally loaded so we use it all the time in production
  # like environments.
  #
  # The rails_semantic_logger gem overwrites the log initializer code and by
  # this point its too late to monkey patch that
  $stdout.sync = true
  SemanticLogger.application = ENV["SEMANTIC_LOGGER_APP"].presence || "Get into Teaching App"
  config.rails_semantic_logger.started = false
  config.rails_semantic_logger.processing = false
  config.rails_semantic_logger.format = :json
  config.rails_semantic_logger.add_file_appender = false
  config.rails_semantic_logger.filter = proc { |log| log.name != "DfE::Analytics::SendEvents" }
  config.semantic_logger.add_appender \
    io: $stdout,
    level: Rails.application.config.log_level,
    formatter: config.rails_semantic_logger.format

  config.x.structured_data.web_site = true
  config.x.structured_data.organization = false
  config.x.structured_data.government_organization = true
  config.x.structured_data.breadcrumb_list = true
  config.x.structured_data.event = true

  config.x.dfe_analytics = true

  # Ensure beta redirect happens before static page cache.
  config.middleware.insert_before ActionDispatch::Static, Rack::HostRedirect, {
    "beta-getintoteaching.education.gov.uk" => "getintoteaching.education.gov.uk",
  }
end
