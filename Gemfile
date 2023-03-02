source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").chomp

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0.2.3"

# Use Puma as the app server
gem "puma", "~> 5.6", ">= 5.6.2"

gem "shakapacker", "6.5.6"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.12.0", require: false

# Temporarily adding as part of Ruby 3.1 upgrade, we should be able
# to remove them once we're on Rails 7.0.1+
gem "net-imap", require: false
gem "net-pop", require: false

# Manage multiple processes i.e. web server and webpack
gem "foreman"

gem "secure_headers"

# Canonical meta tag
gem "canonical-rails", ">= 0.2.14"

gem "front_matter_parser", github: "waiting-for-dev/front_matter_parser"
gem "kramdown", ">= 2.4.0"
gem "rinku"

gem "addressable", "~> 2.8.1"

gem "rack-attack"

gem "faraday", "~> 1.10.0"
gem "faraday-encoding"
gem "faraday-http-cache"
gem "faraday_middleware"

gem "fastimage"

gem "dfe-analytics", github: "DFE-Digital/dfe-analytics", tag: "v1.5.3"

gem "hashids"

gem "dotenv-rails", ">= 2.7.6"

gem "govuk_design_system_formbuilder", ">= 2.8.0"

gem "loaf", ">= 0.10.0"

gem "prometheus-client"

gem "sentry-rails", ">= 5.4.1"
gem "sentry-ruby", "~> 5.4.1"

gem "skylight", "~> 5.3.4"

gem "text"

gem "get_into_teaching_api_client_faraday", github: "DFE-Digital/get-into-teaching-api-ruby-client", require: "api/client"
gem "redis"
gem "redis-session-store", ">= 0.11.4"

gem "kaminari", "~> 1.2", ">= 1.2.2"
gem "view_component", "~> 2.78.0"

gem "google-api-client", ">= 0.53.0", require: false

gem "net-smtp", require: false
gem "rack-page_caching", github: "pkorenev/rack-page_caching", ref: "9ca404f"

# Fix CVE errors
gem "delegate", ">= 0.2.0"
gem "logger", ">= 1.5.1"
gem "matrix", ">= 0.4.2"
gem "observer", ">= 0.1.0"
gem "rexml", ">= 3.2.5"

# Drawing curved arrow SVGs
gem "geometry", github: "bfoz/geometry", ref: "3054ccb"
gem "victor"

# Ignore cloudfront IPs when getting customer IP address
gem "actionpack-cloudfront", ">= 1.2.0"

# HTML-aware ERB parsing
gem "better_html", ">= 1.0.16"

gem "git_wizard", github: "DFE-Digital/get-into-teaching-wizard"

gem "rack-host-redirect"

gem "rack-cors"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]

  # GOV.UK interpretation of rubocop for linting Ruby
  gem "rubocop-govuk", "~> 4.3.0"

  # Static security scanner
  gem "brakeman", "~> 5.2.3", require: false

  # Debugging
  gem "pry-byebug"
  gem "pry-rails"

  # Testing framework
  gem "knapsack"
  gem "rspec-rails", "~> 6.0.1"

  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 3.37"
  gem "factory_bot_rails", ">= 6.2.0"
  # See: https://github.com/otherguy/rspec-sonarqube-formatter/pull/63
  gem "rspec-sonarqube-formatter", github: "otherguy/rspec-sonarqube-formatter", ref: "13fe436", require: false
  gem "simplecov"

  # Linting
  gem "erb_lint", ">= 0.1.1", require: false
  gem "mdl"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", "~> 3.7.1"
  gem "web-console", ">= 4.2.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
end

group :test do
  gem "rspec-retry"
  gem "selenium-webdriver", "~> 3.142"
  gem "shoulda-matchers"
  gem "webmock", ">= 3.14.0"
end

group :rolling, :preprod, :production, :pagespeed do
  # loading the Gem monkey patches rails logger
  # only load in prod-like environments when we actually need it
  gem "amazing_print"
  gem "rails_semantic_logger", ">= 4.10.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
