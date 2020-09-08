require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

require "prometheus/client/data_stores/direct_file_store"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

PROMETHEUS_DIR = "/tmp/prometheus".freeze

# Needs to clear before initializing.
Dir["#{PROMETHEUS_DIR}/*.bin"].each do |file_path|
  File.unlink(file_path)
end

# The DirectFileStore is the only way to aggregate metrics across processes.
file_store = Prometheus::Client::DataStores::DirectFileStore.new(dir: PROMETHEUS_DIR)
Prometheus::Client.config.data_store = file_store

module GovukRailsBoilerplate
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes
  end
end
