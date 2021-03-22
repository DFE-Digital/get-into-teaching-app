source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").chomp

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.3"

# Use Puma as the app server
gem "puma", "~> 5.2"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker"

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Manage multiple processes i.e. web server and webpack
gem "foreman"

gem "secure_headers"

# Canonical meta tag
gem "canonical-rails"

gem "front_matter_parser", github: "waiting-for-dev/front_matter_parser"
gem "kramdown"
gem "rinku"

gem "addressable"

gem "rack-attack"

gem "faraday"
gem "faraday-encoding"
gem "faraday-http-cache"
gem "faraday_middleware"

gem "dotenv-rails"

gem "govuk_design_system_formbuilder"

gem "loaf"

gem "prometheus-client"

gem "sentry-rails"
gem "sentry-ruby"

gem "get_into_teaching_api_client_faraday", github: "DFE-Digital/get-into-teaching-api-ruby-client", require: "api/client"
gem "redis"

gem "kaminari", "~> 1.2"
gem "view_component"

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
  gem "capybara", "~> 3.35"
  gem "factory_bot_rails"
  gem "rspec-sonarqube-formatter", "~> 1.5", require: false
  gem "simplecov"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.5"
  gem "web-console", ">= 3.3.0"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "shoulda-matchers"
  gem "webdrivers", "~> 4.6"
  gem "webmock"
end

group :rolling, :preprod, :userresearch, :production do
  # loading the Gem monkey patches rails logger
  # only load in prod-like environments when we actually need it
  gem "amazing_print"
  gem "rails_semantic_logger"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
