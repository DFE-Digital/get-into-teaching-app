# Just use the production settings
require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  # Override any production defaults here
  config.x.git_api_endpoint = \
    "https://getintoteachingapi-development.test.teacherservices.cloud/api"

  config.view_component.show_previews = true

  config.x.display_content_errors = true

  config.x.dfe_analytics = ENV["DFE_ANALYTICS"]
end
