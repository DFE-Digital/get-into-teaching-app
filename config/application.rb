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

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GetIntoTeachingWebsite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes

    # View component previews
    config.view_component.preview_paths << Rails.root.join("spec/components/previews")
    config.view_component.default_preview_layout = "component_preview"

    config.skylight.environments.append("preprod", "dev", "test", "staging", "userresearch", "rolling")

    # Static page cache
    config.action_controller.page_cache_directory = Rails.root.join("public/cached_pages")
    config.middleware.insert_before \
      ActionDispatch::Static, ActionDispatch::Static, File.join(config.root, "public", "cached_pages"),
      headers: { "Cache-Control" => "max-age=#{5.minutes.to_i}, public, immutable" }
  end
end

# Prevent Rails from attempting to auto-load JS/assets.
Rails.autoloaders.main.ignore(Rails.root.join("app/webpacker"))
