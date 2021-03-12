Sentry.init do |config|
  if ENV["SENTRY_DSN"].blank? && Rails.application.credentials.sentry_dsn.present?
    config.dsn = Rails.application.credentials.sentry_dsn
  end
end
