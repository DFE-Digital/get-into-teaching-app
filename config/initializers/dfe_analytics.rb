DfE::Analytics.configure do |config|
  # Whether to log events instead of sending them to BigQuery.
  #
  config.log_only = false

  # Whether to use ActiveJob or dispatch events immediately.
  #
  config.async = true

  # Which ActiveJob queue to put events on
  #
  config.queue = :dfe_analytics

  # The name of the BigQuery table we’re writing to.
  #
  # config.bigquery_table_name = ENV['BIGQUERY_TABLE_NAME']

  # The name of the BigQuery project we’re writing to.
  #
  # config.bigquery_project_id = ENV['BIGQUERY_PROJECT_ID']

  # The name of the BigQuery dataset we're writing to.
  #
  # config.bigquery_dataset = ENV['BIGQUERY_DATASET']

  # Service account JSON key for the BigQuery API. See
  # https://cloud.google.com/bigquery/docs/authentication/service-account-file
  #
  # We base64 encode the secret otherwise the raw JSON is mangled when it gets
  # written to/read from the Azure keyvault.
  config.bigquery_api_json_key = ENV["BIGQUERY_API_JSON_KEY"] ? Base64.decode64(ENV["BIGQUERY_API_JSON_KEY"]) : nil

  # Passed directly to the retries: option on the BigQuery client
  #
  # config.bigquery_retries = 3

  # Passed directly to the timeout: option on the BigQuery client
  #
  # config.bigquery_timeout = 120

  # A proc which returns true or false depending on whether you want to
  # enable analytics. You might want to hook this up to a feature flag or
  # environment variable.
  #
  config.enable_analytics = proc { Rails.application.config.x.dfe_analytics }

  # The environment we’re running in. This value will be attached
  # to all events we send to BigQuery.
  #
  # config.environment = ENV.fetch('RAILS_ENV', 'development')

  config.user_identifier = proc { |user| user&.username }

  config.entity_table_checks_enabled = true

  # A proc which will be called with the rack env, and which should
  # return a boolean indicating whether the page is cached and will
  # be served by rack middleware.

  config.rack_page_cached = proc do |rack_env|
    Rails.application.config.action_controller.perform_caching &&
      ActionDispatch::FileHandler.new(Rails.root.join("public/cached_pages").to_s).attempt(rack_env).present?
  end
end
