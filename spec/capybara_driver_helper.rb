require "capybara/rspec"
require "webdrivers/chromedriver"

JS_DRIVER = :selenium_chrome_headless

Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = JS_DRIVER
  config.server = :puma, { Silent: true }
  config.always_include_port = true
end

Capybara.default_max_wait_time = 2
RSpec.configure do |config|
  config.before(:each) do |example|
    Capybara.current_driver = JS_DRIVER if example.metadata[:js]
    Capybara.current_driver = :selenium if example.metadata[:selenium]
    Capybara.current_driver = :selenium_chrome if example.metadata[:selenium_chrome]
  end

  config.after(:each) do
    Capybara.use_default_driver
  end
end

WebMock.disable_net_connect!(allow_localhost: true, allow: %w[localhost])
