require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  config.public_file_server.headers =
    {
      "Cache-Control" => "max-age=31536000, public, immutable",
      "Access-Control-Allow-Origin" => ENV["APP_URL"],
    }

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  # config.public_file_server.enabled = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  if ENV["APP_ASSETS_URL"].present?
    config.action_controller.asset_host = ENV["APP_ASSETS_URL"]
  end
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # # Log to STDOUT by default
  # config.logger = ActiveSupport::Logger.new(STDOUT)
  #   .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
  #   .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  # config.force_ssl = true
  unless ENV["SKIPSSL"].in? %w[1 true yes]
    config.force_ssl = true
    config.ssl_options = { redirect: { exclude: ->(request) { request.path.include?("/check") } } }
  end
  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info
  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  # config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
  config.cache_store = :redis_cache_store, { namespace: "GIT" }

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "get_into_teaching_website_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  # config.active_support.report_deprecations = false

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Inserts middleware to perform automatic connection switching.
  # The `database_selector` hash is used to pass options to the DatabaseSelector
  # middleware. The `delay` is used to determine how long to wait after a write
  # to send a subsequent read to the primary.
  #
  # The `database_resolver` class is used by the middleware to determine which
  # database is appropriate to use based on the time delay.
  #
  # The `database_resolver_context` class is used by the middleware to set
  # timestamps for the last write to the primary. The resolver uses the context
  # class timestamps to determine how long to wait before reading from the
  # replica.
  #
  # By default Rails will store a last write timestamp in the session. The
  # DatabaseSelector middleware is designed as such you can define your own
  # strategy for connection switching and pass that into the middleware through
  # these configuration options.
  # config.active_record.database_selector = { delay: 2.seconds }
  # config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  # config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

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
