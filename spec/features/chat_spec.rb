require "rails_helper"

RSpec.feature "Chat", type: :feature do
  include_context "when requesting a page with the Get Into Teaching events badge"

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/")
    stub_request(:get, "http://api.example/")
      .to_return(status: 200, body: "{\"skillid\": 123456, \"available\": false, \"status_age\": 123 }")
  end

  scenario "test" do
    puts "TEST1g"
    visit root_path
    puts "TEST2g"
  end


  # before do
  #   allow(ENV).to receive(:fetch).and_call_original
  #   allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/")
  #   stub_request(:get, "http://api.example/")
  #     .to_return(status: 200, body: "{\"skillid\": 123456, \"available\": false, \"status_age\": 123 }")
  # end

  # context "when javascript is enabled", :js do
  #   # context "when agents are available" do
  #   #   before do
  #   #     stub_request(:get, "http://api.example/")
  #   #       .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": true, \"status_age\": 123 }")
  #   #   end
  #   #
  #   #   scenario "viewing the chat section of the talk to us component" do
  #   #     visit root_path
  #   #     dismiss_cookies
  #   #
  #   #     within(".talk-to-us") do
  #   #       click_link("Open chat in new tab")
  #   #     end
  #   #
  #   #     popup_window_handle = (page.driver.browser.window_handles - [page.driver.current_window_handle]).first
  #   #     page.driver.switch_to_window(popup_window_handle)
  #   #     expect(page.driver.current_url).to end_with("/chat")
  #   #     expect(page).to have_css("#root", visible: false)
  #   #     page.driver.close_window(popup_window_handle)
  #   #   end
  #   # end
  #
  #   context "when agents are not available" do
  #     before do
  #       stub_request(:get, "http://api.example/")
  #         .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": false, \"status_age\": 123 }")
  #     end
  #
  #     scenario "viewing the chat section of the talk to us component" do
  #       puts "TEST A: #{ENV["CHAT_AVAILABILITY_API"]}"
  #       # puts "TEST B: #{ENV.fetch("CHAT_AVAILABILITY_API")}"
  #       puts "TEST C: #{ENV.fetch("CHAT_AVAILABILITY_API", nil)}"
  #       puts "TEST D: #{Chat.new.availability_api_uri}"
  #       puts "TEST E: #{Chat.new.availability}"
  #
  #       puts "TEST1"
  #       visit root_path
  #       puts "TEST2"
  #       dismiss_cookies
  #       puts "TEST3c"
  #
  #       within(".talk-to-us") do
  #         expect(page).to have_text("Chat is closed")
  #       end
  #     end
  #   end
  # end

  # context "when javascript is not enabled", js: false do
  #   scenario "viewing the chat section of the talk to us component" do
  #     visit root_path
  #     dismiss_cookies
  #
  #     within(".talk-to-us") do
  #       expect(page).to have_text("Chat not available")
  #     end
  #   end
  # end

  # def dismiss_cookies
  #   click_link "Accept all cookies"
  # end


  # def visit_on_date(path)
  #   visit "#{path}?fake_browser_time=#{date.to_i * 1000}"
  # end
end
