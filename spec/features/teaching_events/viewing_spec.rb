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

      expect(page).to have_css("h2", text: "Event information")
      expect(page).to have_css("h2", text: "Provider information")

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
      within(".teaching-event__provider-information") do
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

  describe "instructions on attending" do
    let(:register_link_text) { "Register for this event" }

    before { visit teaching_event_path(event.readable_id) }

    subject { page }

    context "when can the event can be signed up for online" do
      let(:event) { build(:event_api) }

      it { is_expected.to have_content("To attend this event, you must register for a place") }
      it { is_expected.to have_link(register_link_text) }
    end

    context "when can the event can't be signed up for online" do
      context "when it's a School or University event" do
        let(:event) { build(:event_api, :school_or_university_event, web_feed_id: nil) }

        it { is_expected.to have_content("To register for this event, follow the instructions in the event information section.") }
        it { is_expected.not_to have_link(register_link_text) }
      end

      context "when it's not a School or University event" do
        context "when the provider has a website" do
          let(:url) { "https://event-provider.com" }
          let(:event) { build(:event_api, :online_event, web_feed_id: nil, provider_website_url: url) }

          it { is_expected.to have_content("To attend this event, please visit this website") }
          it { is_expected.to have_link("visit this website", href: url) }
          it { is_expected.not_to have_link(register_link_text) }
        end

        context "when the provider has an email address" do
          let(:email) { "events@event-provider.com" }
          let(:event) { build(:event_api, :online_event, web_feed_id: nil, provider_contact_email: email) }

          it { is_expected.to have_content("To attend this event, please email us") }
          it { is_expected.to have_link("email us", href: "mailto:" + email) }
          it { is_expected.not_to have_link(register_link_text) }
        end
      end
    end
  end

  describe "viewing a past event" do
    let(:event) { build(:event_api) }

    before do
      allow_any_instance_of(EventStatus).to receive(:viewable?).and_return(false)
    end

    scenario do
      visit teaching_event_path(event.readable_id)

      expect(page).to have_css("h1", text: "Unfortunately that event has already happened")
      expect(page).to have_link("All events", href: "/teaching-events", class: "button")
    end
  end
end
