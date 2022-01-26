require "rails_helper"

RSpec.feature "Chat", type: :feature do
  around do |example|
    travel_to(date.in_time_zone("London")) { example.run }
  end

  context "when Javascript is enabled", js: true do
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
          expect(page).to have_link("getintoteaching.getintoteaching@education.gov.uk")
        end
      end
    end

    context "when chat is offline" do
      let(:date) { Time.zone.local(2021, 1, 1, 7) }

      scenario "viewing the chat section of the talk to us component" do
        visit_on_date root_path

        within(".talk-to-us") do
          expect(page).to have_text("Chat not available")
          expect(page).to have_link("getintoteaching.getintoteaching@education.gov.uk")
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
