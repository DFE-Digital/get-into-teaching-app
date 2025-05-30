# This file is copied to spec/ when you run 'rails generate rspec:install'
#
# NB: This is a heavy-weight file. Only include it in your specs if you need the
# full Rails infrastructure for your test. Otherwise use the light-weight
# spec_helper instead (which is included here)
require "spec_helper"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
# Prevent database truncation if the environment is production
unless Rails.env.development? || Rails.env.test?
  abort("The Rails environment is running in #{Rails.env} mode!")
end

# Add additional requires below this line. Rails is not loaded until this point!
require "rspec/rails"
require "active_record"
require "view_component/test_helpers"
require "dfe/analytics/rspec/matchers"

require_relative "capybara_driver_helper"
require "dfe/analytics/testing"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   puts e.to_s.strip
#   exit 1
# end

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each do |f|
  require f
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include FactoryBot::Syntax::Methods
  config.include ViewComponent::TestHelpers, type: :component
  config.include ActiveSupport::Testing::TimeHelpers
  config.include SpecHelpers::BasicAuth
  config.include SpecHelpers::Integration, type: :feature
  config.include SpecHelpers::Contract, type: :feature
  config.include Shakapacker::Helper, type: :helper

  config.verbose_retry = true
  config.default_retry_count = 2
  # We occasionally see timeout errors on features/chat_spec.rb.
  # The source of the flakiness isn't clear, so allowing retries
  # for now to hopefully avoid it failing builds outright.
  config.exceptions_to_retry = [Net::ReadTimeout]

  config.before(:suite) do
    Shakapacker.compile
  end

  config.before do
    ActiveJob::Base.queue_adapter = :test

    # If we don't mock this out for some pages it can result
    # in FastImage trying to make an external web request (even
    # though its actually just to our test host). Returning nil
    # is the same as FastImage failing to determine the size.
    allow(FastImage).to receive(:size).and_return(nil)
  end
end

DfE::Analytics::Testing.fake!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
