# Just use the production settings
require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  # Override any production defaults here
  config.x.git_api_endpoint = \
    "https://get-into-teaching-api-dev.london.cloudapps.digital/api"
  config.x.static_pages.disable_caching = true
  config.x.utm_codes = true

  Rack::Attack.enabled = false
end
