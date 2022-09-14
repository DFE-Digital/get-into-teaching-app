# Just use the production settings
require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  # Override any production defaults here
  config.x.git_api_endpoint = \
    "https://get-into-teaching-api-dev.london.cloudapps.digital/api"

  config.view_component.show_previews = true

  config.x.display_content_errors = true

  config.x.dfe_analytics = true
end
