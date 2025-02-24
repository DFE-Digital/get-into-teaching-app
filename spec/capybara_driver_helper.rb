require "capybara/rspec"
require "capybara/mechanize"

JS_DRIVER = :selenium_chrome_headless
MECHANIZE_DRIVER = :mechanize

Capybara.register_driver JS_DRIVER do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_driver MECHANIZE_DRIVER do |app|
  driver = Capybara::Mechanize::Driver.new(app)
  driver.configure do |agent|
    # Configure other Mechanize options here.
    # agent.log = Logger.new "mechanize.log"
  end
  driver
end

Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = JS_DRIVER
  config.server = :puma, { Silent: true }
  config.always_include_port = true
end

Capybara.default_max_wait_time = 2
RSpec.configure do |config|
  config.before do |example|
    Capybara.current_driver = JS_DRIVER if example.metadata[:js]
    Capybara.current_driver = :selenium if example.metadata[:selenium]
    Capybara.current_driver = :selenium_chrome if example.metadata[:selenium_chrome]
    Capybara.current_driver = MECHANIZE_DRIVER if example.metadata[:mechanize]
  end

  config.after do
    Capybara.use_default_driver
  end
end

WebMock.disable_net_connect!(allow_localhost: true)
