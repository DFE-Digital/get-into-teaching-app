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
    config.load_defaults 7.0

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
    config.view_component.preview_controller = "PreviewController"
    config.view_component.preview_paths << Rails.root.join("spec/components/previews")
    config.view_component.default_preview_layout = "component_preview"

    config.skylight.environments.append("preprod", "dev", "test", "staging", "rolling")
  end
end

# Prevent Rails from attempting to auto-load JS/assets.
Rails.autoloaders.main.ignore(Rails.root.join("app/webpacker"))
