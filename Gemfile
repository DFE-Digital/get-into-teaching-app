source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").chomp

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.3", ">= 6.1.3.2"

# Use Puma as the app server
gem "puma", "~> 5.3", ">= 5.3.1"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", ">= 5.4.0"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Manage multiple processes i.e. web server and webpack
gem "foreman"

gem "secure_headers"

# Canonical meta tag
gem "canonical-rails", ">= 0.2.11"

gem "front_matter_parser", github: "waiting-for-dev/front_matter_parser"
gem "kramdown", ">= 2.3.1"
gem "rinku"

gem "addressable"

gem "rack-attack"

gem "faraday"
gem "faraday-encoding"
gem "faraday-http-cache"
gem "faraday_middleware"

gem "dotenv-rails", ">= 2.7.6"

gem "govuk_design_system_formbuilder", ">= 2.5.3"

gem "loaf", ">= 0.10.0"

gem "prometheus-client"

gem "sentry-rails", ">= 4.3.4"
gem "sentry-ruby"

gem "skylight", "~> 5.1.1"

gem "text"

gem "get_into_teaching_api_client_faraday", github: "DFE-Digital/get-into-teaching-api-ruby-client", require: "api/client"
gem "redis"

gem "kaminari", "~> 1.2", ">= 1.2.1"
gem "view_component", "~> 2.32.0"

gem "google-api-client", ">= 0.53.0", require: false

# Ignore cloudfront IPs when getting customer IP address
gem "actionpack-cloudfront", ">= 1.1.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]

  # GOV.UK interpretation of rubocop for linting Ruby
  gem "rubocop-govuk", "~> 3.14.0" # FIXME: stop gap fix but we should relint the codebase

  # Static security scanner
  gem "brakeman", require: false

  # Debugging
  gem "pry-byebug"
  gem "pry-rails"

  # Testing framework
  gem "rspec-rails", "~> 5.0.1"
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 3.35", ">= 3.35.3"
  gem "factory_bot_rails", ">= 6.1.0"
  gem "parallel_split_test"
  gem "rspec-sonarqube-formatter", "~> 1.5", require: false
  gem "simplecov"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.6"
  gem "web-console", ">= 4.1.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "selenium-webdriver", "~> 3.142"
  gem "shoulda-matchers"
  gem "webmock", ">= 3.12.2"
end

group :rolling, :preprod, :userresearch, :production, :pagespeed do
  # loading the Gem monkey patches rails logger
  # only load in prod-like environments when we actually need it
  gem "amazing_print"
  gem "rails_semantic_logger", ">= 4.5.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
