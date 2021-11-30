require "rails_helper"

RSpec.feature "Searching for teaching events", type: :feature do
  include_context "with stubbed types api"

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).and_return(event)
  end

  shared_examples "train-to-teach teaching event" do
    scenario "the page has the right contents" do
      visit teaching_event_path(event.readable_id)

      expect(page).to have_current_path("/teaching-events/#{event.readable_id}")

      expect(page).to have_css("h1", text: event.name)

      expect(page).to have_css(".date-and-time", text: event.start_at.to_formatted_s(:event))
      expect(page).to have_css(".date-and-time", text: event.start_at.to_formatted_s(:time))
      expect(page).to have_css(".date-and-time", text: event.end_at.to_formatted_s(:time))

      expect(page).to have_link("Register for this event", href: event_steps_path(event.readable_id), count: 2)

      expect(page).to have_css("h2", text: "Event information")
      expect(page).to have_css("h2", text: "Venue information")

      expect(page).not_to have_css("h2", text: "Provider information")
    end
  end

  shared_examples "regular teaching event" do |expect_venue|
    scenario "the page has the right contents" do
      visit teaching_event_path(event.readable_id)

      expect(page).to have_current_path("/teaching-events/#{event.readable_id}")

      expect(page).to have_css("h1", text: event.name)

      expect(page).to have_css(".date-and-time", text: event.start_at.to_formatted_s(:event))
      expect(page).to have_css(".date-and-time", text: event.start_at.to_formatted_s(:time))
      expect(page).to have_css(".date-and-time", text: event.end_at.to_formatted_s(:time))

      expect(page).not_to have_css(".register")

      expect(page).to have_css("h2", text: "Event information")
      expect(page).to have_css("h2", text: "Provider information")

      expect(page).not_to have_link("Register for this event")

      if expect_venue
        expect(page).to have_css("h2", text: "Venue information")
      else
        expect(page).not_to have_css("h2", text: "Venue information")
      end
    end
  end

  describe "viewing a train to teach event" do
    let(:event) { build(:event_api, :with_provider_info) }

    include_examples "train-to-teach teaching event"
  end

  describe "viewing a question time event" do
    let(:event) { build(:event_api, :question_time_event, :with_provider_info) }

    include_examples "train-to-teach teaching event"
  end

  describe "viewing a online event" do
    let(:event) { build(:event_api, :online_event, :with_provider_info) }

    include_examples "regular teaching event", false
  end

  describe "viewing a school or university event" do
    let(:event) { build(:event_api, :school_or_university_event, :with_provider_info) }

    include_examples "regular teaching event", true
  end

  describe "provider information" do
    let(:event) { build(:event_api, :school_or_university_event, :with_provider_info) }

    before { visit teaching_event_path(event.readable_id) }

    specify "the provider info is included on the page" do
      within(".teaching-event__provider-info") do
        expect(page).to have_css("h2", text: "Provider information")

        expect(page).to have_content("Event website")
        expect(page).to have_link(event.provider_website_url)

        expect(page).to have_content("Target audience")
        expect(page).to have_content(event.provider_target_audience)

        expect(page).to have_content("Organiser")
        expect(page).to have_content(event.provider_organiser)

        expect(page).to have_content("Contact email")
        expect(page).to have_link(event.provider_contact_email)
      end
    end
  end
end
