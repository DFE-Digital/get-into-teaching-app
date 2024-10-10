require "rails_helper"

RSpec.feature "Chat", type: :feature do
  include_context "when requesting a page with the Get Into Teaching events badge"

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("CHAT_ENABLED", false).and_return(new_chat_enabled)
    allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/")
    stub_request(:get, "http://api.example/")
      .to_return(status: 200, body: "{\"skillid\": 123456, \"available\": false, \"status_age\": 123 }")
  end

  context "when new-chat is enabled" do
    let(:new_chat_enabled) { "1" }

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
            click_link("Chat online")
          end

          popup_window_handle = (page.driver.browser.window_handles - [page.driver.current_window_handle]).first
          page.driver.switch_to_window(popup_window_handle)
          expect(page.driver.current_url).to end_with("/chat")
          expect(page).to have_css("#root", visible: false)
          page.driver.close_window(popup_window_handle)
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
  end

  context "when old-chat is enabled" do
    let(:new_chat_enabled) { "0" }

    around do |example|
      travel_to(date.in_time_zone("London")) { example.run }
    end

    context "when Javascript is enabled", :js do
      context "when chat is online" do
        let(:date) { Time.zone.local(2021, 1, 1, 9) }

        scenario "viewing the chat section of the talk to us component" do
          visit_on_date root_path
          dismiss_cookies

          within(".talk-to-us") do
            click_link("Chat online")
            expect(page).to have_link("Starting chat...")
          end
        end
      end

      context "when chat is offline" do
        let(:date) { Time.zone.local(2021, 1, 1, 5) }

        scenario "viewing the chat section of the talk to us component" do
          visit_on_date root_path
          dismiss_cookies

          within(".talk-to-us") do
            expect(page).to have_text("Chat is closed")
          end
        end
      end
    end

    context "when Javascript is disabled" do
      context "when chat is online" do
        let(:date) { Time.zone.local(2021, 1, 1, 9) }

        scenario "viewing the chat section of the talk to us component" do
          visit_on_date root_path

          within(".talk-to-us") do
            expect(page).to have_text("Chat not available")
            expect(page).to have_link("getinto.teaching@service.education.gov.uk")
          end
        end
      end

      context "when chat is offline" do
        let(:date) { Time.zone.local(2021, 1, 1, 7) }

        scenario "viewing the chat section of the talk to us component" do
          visit_on_date root_path

          within(".talk-to-us") do
            expect(page).to have_text("Chat not available")
            expect(page).to have_link("getinto.teaching@service.education.gov.uk")
          end
        end
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
