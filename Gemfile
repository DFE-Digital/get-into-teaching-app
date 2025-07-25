source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").chomp

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 8.0"

# Use Puma as the app server
gem "puma", "~> 6.4"

gem "pg"

gem "validates_timeliness"

gem "invisible_captcha"

gem "iso_country_codes"

gem "shakapacker", "8.1.0"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.16.0", require: false

# Temporarily adding as part of Ruby 3.1 upgrade, we should be able
# to remove them once we're on Rails 7.0.1+
gem "net-imap", require: false
gem "net-pop", require: false

# Manage multiple processes i.e. web server and webpack
gem "foreman"

gem "secure_headers"

gem "nokogiri", ">= 1.14.3"

# Canonical meta tag
gem "canonical-rails", ">= 0.2.14"

gem "front_matter_parser", github: "waiting-for-dev/front_matter_parser"
gem "kramdown", ">= 2.4.0"
gem "rinku"

gem "addressable", "~> 2.8.7"

gem "rack-attack"

gem "faraday", "~> 1.10.0"
gem "faraday-encoding"
gem "faraday-http-cache"
gem "faraday_middleware"

gem "fastimage"

gem "dfe-analytics", github: "DFE-Digital/dfe-analytics", tag: "v1.15.1"
gem "dfe-autocomplete", require: "dfe/autocomplete", github: "DFE-Digital/dfe-autocomplete"
gem "dfe-reference-data", require: "dfe/reference_data", github: "DFE-Digital/dfe-reference-data", tag: "v3.6.9"

gem "benchmark"
gem "hashids"
gem "irb"
gem "mutex_m"
gem "ostruct"
gem "reline"

gem "dotenv-rails", ">= 2.7.6"

gem "govuk_design_system_formbuilder", ">= 2.8.0"

gem "loaf", ">= 0.10.0"

gem "prometheus-client"

gem "sentry-rails", ">= 5.10.0"
gem "sentry-ruby", "~> 5.21.0"

gem "skylight", "~> 6.0.4"

gem "text"

gem "indefinite_article"

gem "connection_pool"

gem "get_into_teaching_api_client_faraday", ">= 3.6.0", github: "DFE-Digital/get-into-teaching-api-ruby-client", require: "api/client"

gem "redis"
gem "redis-session-store", ">= 0.11.4"

gem "kaminari", "~> 1.2", ">= 1.2.2"
gem "view_component", "~> 3.21.0"

gem "google-api-client", ">= 0.53.0", require: false

gem "net-smtp", ">= 0.3.3", require: false
gem "rack-page_caching", github: "pkorenev/rack-page_caching", ref: "9ca404f"

# NB: Do not update Sidekiq beyond version 6.5.5, as newer versions are incompatible
# with the Redis instance we are using on AKS
gem "sidekiq", ">= 6.5.5", "< 6.5.6"
gem "sidekiq-cron"

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
  gem "rubocop-govuk", "~> 5.1.14"

  # Static security scanner
  gem "brakeman", "~> 7.0.2", require: false

  gem "drb"

  # Debugging
  gem "pry-byebug"
  gem "pry-rails"

  # Testing framework
  gem "knapsack"
  gem "rspec-rails", "~> 8.0"

  # Adds support for Capybara system testing
  gem "capybara", "~> 3.40.0"
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
  gem "listen", "~> 3.9.0"
  gem "web-console", ">= 4.2.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
end

group :test do
  gem "capybara-mechanize"
  gem "nkf"
  gem "rspec-retry"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "vcr"
  gem "webmock", ">= 3.14.0"
end

group :rolling, :preprod, :production, :pagespeed do
  # loading the Gem monkey patches rails logger
  # only load in prod-like environments when we actually need it
  gem "amazing_print"
  gem "rails_semantic_logger", ">= 4.12.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
