require "rails_helper"

RSpec.feature "Chat", type: :feature do
  include_context "when requesting a page with the Get Into Teaching events badge"

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/")
    stub_request(:get, "http://api.example/")
      .to_return(status: 200, body: "{\"skillid\": 123456, \"available\": false, \"status_age\": 123 }")
    stub_request(:get, "https://get-into-teaching-api-dev.london.cloudapps.digital/api/privacy_policies/latest").
      with(
        headers: {
          'Accept'=>'application/json',
          'Authorization'=>'Bearer test',
          'Content-Type'=>'application/json',
        }).
      to_return(status: 200, body: '{"text":"Privacy Notice","createdAt":"2020-01-13T09:44:50","id":"123"}', headers: {})
  end

  context "when javascript is enabled", :js do
    context "when agents are available" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": true, \"status_age\": 123 }")
      end

      scenario "viewing the chat section of the talk to us component" do
        visit root_path
        dismiss_cookies

        within(".talk-to-us") do
          expect(page).to have_link("Open chat in new tab", href: "/chat#root")
        end
      end
    end

    context "when agents are not available" do
      before do
        stub_request(:get, "http://api.example/")
          .to_return(status: 200, body: "{\"skillid\": 123456,	\"available\": false, \"status_age\": 123 }")
      end

      scenario "viewing the chat section of the talk to us component" do
        visit root_path
        dismiss_cookies

        within(".talk-to-us") do
          expect(page).to have_text("Chat is closed")
        end
      end
    end
  end

  context "when javascript is not enabled", js: false do
    scenario "viewing the chat section of the talk to us component" do
      visit root_path
      dismiss_cookies

      within(".talk-to-us") do
        expect(page).to have_text("Chat not available")
      end
    end
  end

  def dismiss_cookies
    click_link "Accept all cookies"
  end

  def visit_on_date(path)
    visit "#{path}?fake_browser_time=#{date.to_i * 1000}"
  end
end
