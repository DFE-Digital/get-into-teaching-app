InvisibleCaptcha.setup do |config|
  # Only enable in production so our automated integration
  # tests don't fail.
  config.timestamp_enabled = Rails.env.production?
end
