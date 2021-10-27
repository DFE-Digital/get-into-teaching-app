# Just use the production settings
require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  # Override any production defaults here
  config.x.git_api_endpoint = \
    "https://get-into-teaching-api-dev.london.cloudapps.digital/api"
  config.x.enable_beta_redirects = false

  config.view_component.show_previews = true

  config.x.mailing_list_age_step = true

  config.x.zendesk_chat = true

  config.x.legacy_tracking_pixels = false
end
