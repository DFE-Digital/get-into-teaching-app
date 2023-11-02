# Just use the production settings
require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  config.x.feature_flags.feedback_enabled = true

  # Override any production defaults here
  config.x.git_api_endpoint = \
    "https://getintoteachingapi-test.test.teacherservices.cloud/api"
end
