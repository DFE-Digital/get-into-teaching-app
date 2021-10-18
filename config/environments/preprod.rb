# Just use the production settings
require File.expand_path("production.rb", __dir__)

# We have multiple domains that serve the test instance of the app:
#
# get-into-teaching-app-test.london.cloudapps.digital
# staging-getintoteaching.education.gov.uk
#
# We can only set one domain in this header, which means fonts don't work
# on the other. To get around this we need to use a wildcard in test.
Rails.application.configure do
  config.public_file_server.headers["Access-Control-Allow-Origin"] = "*"

  # Override any production defaults here
  config.x.git_api_endpoint = \
    "https://get-into-teaching-api-test.london.cloudapps.digital/api"

  config.view_component.show_previews = true

  config.x.legacy_tracking_pixels = true
end
