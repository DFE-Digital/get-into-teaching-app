Sentry.init do |config|
  if ENV["SENTRY_DSN"].blank? && Rails.application.credentials.sentry_dsn.present?
    config.dsn = Rails.application.credentials.sentry_dsn
  end

  # Sentry::BackgroundWorker requires ActiveRecord, but we don't use it so
  # we have to manually override async and send events synchronously (or they
  # just disappear with no error!).
  config.async = ->(event, hint) { Sentry.send(event, hint) }
end
