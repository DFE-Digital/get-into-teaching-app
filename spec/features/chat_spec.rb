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

      scenario "viewing the chat button of the steps to become a teacher page" do
        visit_on_date "/steps-to-become-a-teacher"
        dismiss_cookies

        within("#step-2") do
          click_link("Chat online for qualifications advice")
          expect(page).to have_link("Starting chat...")
        end
      end

      scenario "viewing the chat CTA of the funding your training page" do
        visit_on_date "/funding-your-training"
        dismiss_cookies

        within(".call-to-action--chat-online") do
          click_link("Chat online")
          expect(page).to have_link("Starting chat...")
        end
      end

      scenario "viewing the chat tile of the my story into teaching footer" do
        visit_on_date "/my-story-into-teaching/career-changers/transferring-my-skills-to-teaching"
        dismiss_cookies

        within(".feature .card:last-child") do
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
          expect(page).to have_text("Chat closed")
        end
      end

      scenario "viewing the chat button of the steps to become a teacher page" do
        visit_on_date "/steps-to-become-a-teacher"
        dismiss_cookies

        within("#step-2") do
          expect(page).to have_selector(:css, ".chat-button.hidden", visible: :hidden)
        end
      end

      scenario "viewing the chat CTA of the funding your training page" do
        visit_on_date "/funding-your-training"
        dismiss_cookies

        within(".call-to-action--chat-online") do
          expect(page).to have_text("Chat available Monday to Friday between 8:30am and 5:30pm.")
        end
      end

      scenario "viewing the chat tile of the my story into teaching footer" do
        visit_on_date "/my-story-into-teaching/career-changers/transferring-my-skills-to-teaching"
        dismiss_cookies

        within(".feature .card:last-child") do
          expect(page).to have_selector(:css, ".chat-button.hidden", visible: :hidden)
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
          expect(page).to have_text("Email us")
          expect(page).to have_link("getintoteaching.getintoteaching@education.gov.uk")
        end
      end

      scenario "viewing the chat button of the steps to become a teacher page" do
        visit_on_date "/steps-to-become-a-teacher"

        within("#step-2") do
          expect(page).to have_link("Chat to us for qualifications advice", href: "#talk-to-us")
        end
      end

      scenario "viewing the chat CTA of the funding your training page" do
        visit_on_date "/funding-your-training"

        within(".call-to-action--chat-online") do
          expect(page).to have_link("Chat to us", href: "#talk-to-us")
        end
      end

      scenario "viewing the chat tile of the my story into teaching footer" do
        visit_on_date "/my-story-into-teaching/career-changers/transferring-my-skills-to-teaching"

        within(".feature .card:last-child") do
          expect(page).to have_link("Chat to us", href: "#talk-to-us")
        end
      end
    end

    context "when chat is offline" do
      let(:date) { Time.zone.local(2021, 1, 1, 7) }

      scenario "viewing the chat section of the talk to us component" do
        visit_on_date root_path

        within(".talk-to-us") do
          expect(page).to have_text("Email us")
          expect(page).to have_link("getintoteaching.getintoteaching@education.gov.uk")
        end
      end

      scenario "viewing the chat button of the steps to become a teacher page" do
        visit_on_date "/steps-to-become-a-teacher"

        within("#step-2") do
          expect(page).to have_link("Chat to us for qualifications advice", href: "#talk-to-us")
        end
      end

      scenario "viewing the chat CTA of the funding your training page" do
        visit_on_date "/funding-your-training"

        within(".call-to-action--chat-online") do
          expect(page).to have_link("Chat to us", href: "#talk-to-us")
        end
      end

      scenario "viewing the chat tile of the my story into teaching footer" do
        visit_on_date "/my-story-into-teaching/career-changers/transferring-my-skills-to-teaching"

        within(".feature .card:last-child") do
          expect(page).to have_link("Chat to us", href: "#talk-to-us")
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
