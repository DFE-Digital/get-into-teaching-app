require "rails_helper"

RSpec.feature "Register a provider event", type: :feature do
  include_context "with wizard data"

  describe "Registration steps" do
    before { visit provider_events_steps_path }

    it "navigates the steps" do
      expect(page).to have_link(href: provider_events_step_path(ProviderEvents::Steps::Email.key))
      click_on "Start now"

      expect(page).to have_field("What is your email address?")
      fill_in "What is your email address?", with: "test@test.test"
      click_on "Next step"

      expect(page).to have_field("What is the name of your event?")
      fill_in "What is the name of your event?", with: "Super-duper Event"
      click_on "Next step"

      expect(page).to have_field("Describe your event")
      fill_in "Describe your event", with: "Lorem ipsum dolor sit amet"
      click_on "Next step"

      expect(page).to have_field("What is the name of your organisation?")
      fill_in "What is the name of your organisation?", with: "Training Organisation"
      click_on "Next step"

      expect(page).to have_field("Provide your website URL")
      fill_in "Provide your website URL", with: "https://www.example.com"
      click_on "Next step"
    end
  end
end
