require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Patch to Rack::PageCaching::Utils to substitute Fixnum --> Integer
require_relative "../lib/patch_rack_page_caching"

module GetIntoTeachingWebsite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.exceptions_app = routes
    config.active_job.queue_adapter = :sidekiq

    # View component previews
    config.view_component.previews.controller = "PreviewController"
    config.view_component.previews.paths << Rails.root.join("spec/components/previews")
    config.view_component.previews.default_layout = "component_preview"

    config.skylight.environments.append("preprod", "dev", "test", "staging", "rolling")

    # Log Skylight to STDOUT
    config.skylight.logger = Logger.new($stdout)

    config.active_record.encryption.primary_key = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]
    config.active_record.encryption.deterministic_key = ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"]
    config.active_record.encryption.key_derivation_salt = ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"]
  end
end

# Prevent Rails from attempting to auto-load JS/assets.
Rails.autoloaders.main.ignore(Rails.root.join("app/webpacker"))
