require "capybara/rspec"
# require "capybara-screenshot/rspec"

capybara_browser_options = {}.tap do |browser_opts|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument("--headless")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--disable-gpu")
    opts.add_argument("--window-size=1920,1080")
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument("--disable-site-isolation-trials")
  end

  browser_opts[:browser] = :chrome
  browser_opts[options_key] = browser_options
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.new(app, **capybara_browser_options)
end

# Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
#   driver.browser.save_screenshot path
# end

Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = :headless_chrome
  config.server = :puma, { Silent: true }
  config.always_include_port = true
end

Capybara.default_max_wait_time = 2
RSpec.configure do |config|
  config.before do |example|
    Capybara.current_driver = :headless_chrome if example.metadata[:js]
  end

  config.after do
    Capybara.use_default_driver
  end
end

WebMock.disable_net_connect!(allow_localhost: true)



# JS_DRIVER = :selenium_chrome_headless
# Capybara.register_driver JS_DRIVER do |app|
#   options = ::Selenium::WebDriver::Chrome::Options.new
#
#   options.add_argument("--headless")
#   options.add_argument("--no-sandbox")
#   options.add_argument("--disable-dev-shm-usage")
#   options.add_argument("--window-size=1400,1400")
#
#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end
