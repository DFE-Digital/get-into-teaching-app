require "rails_helper"

RSpec.feature "Chat", type: :feature do
  include_context "when requesting a page with the Get Into Teaching events badge"

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/")
  end

  context "when agents are available" do
    before do
      stub_request(:get, "http://api.example/")
        .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": true, \"status_age\": 123 }")
    end

    scenario "viewing the chat section of the talk to us component" do
      visit root_path
      dismiss_cookies

      within(".talk-to-us") do
        click_link("Open chat in new tab")
      end

      expect(page.driver.current_url).to end_with("/chat#root")
      expect(page).to have_css("#root", visible: false)
    end
  end

  context "when agents are not available" do
    before do
      stub_request(:get, "http://api.example/")
        .to_return(status: 200, body: "{\"skillid\": 123456, \"available\": false, \"status_age\": 123 }")
    end

    scenario "viewing the chat section of the talk to us component" do
      visit root_path
      dismiss_cookies

      within(".talk-to-us") do
        expect(page).to have_text("Chat is closed")
      end
    end
  end

  def dismiss_cookies
    click_link "Accept all cookies"
  end
end
