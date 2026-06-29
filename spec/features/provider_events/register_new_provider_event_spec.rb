require "rails_helper"

RSpec.feature "Register a new provider event", type: :feature do
  include_context "with wizard data"

  describe "Start page" do
    it "has a link to the email step" do
      visit provider_events_steps_path
      expect(page).to have_link(href: provider_events_step_path(ProviderEvents::Steps::Email.key))
    end
  end
end
