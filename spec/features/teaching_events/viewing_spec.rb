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

      within(".register") do
        expect(page).to have_link("Register for this event", href: event_steps_path(event.readable_id))
      end

      within(".event-info > .event-summary") do
        expect(page).to have_css(".about-ttt-event", text: /Watch presentations, ask questions/)
        expect(page).to have_css("figure", text: "It was exactly what I needed")

        expect(page).not_to have_css(".about-event")
      end
    end
  end

  shared_examples "regular teaching event" do
    scenario "the page has the right contents" do
      visit teaching_event_path(event.readable_id)

      expect(page).to have_current_path("/teaching-events/#{event.readable_id}")

      expect(page).to have_css("h1", text: event.name)

      expect(page).to have_css(".date-and-time", text: event.start_at.to_formatted_s(:event))
      expect(page).to have_css(".date-and-time", text: event.start_at.to_formatted_s(:time))
      expect(page).to have_css(".date-and-time", text: event.end_at.to_formatted_s(:time))

      expect(page).not_to have_css(".register")

      within(".event-info") do
        expect(page).to have_css(".about-event", text: Regexp.new(event.summary))
        expect(page).to have_css(".about-event", text: Regexp.new(Nokogiri.parse(event.description).text))

        expect(page).not_to have_css(".about-ttt-event")
      end
    end
  end

  describe "viewing a train to teach event" do
    let(:event) { build(:event_api) }

    include_examples "train-to-teach teaching event"
  end

  describe "viewing a question time event" do
    let(:event) { build(:event_api, :question_time_event) }

    include_examples "train-to-teach teaching event"
  end

  describe "viewing a online event" do
    let(:event) { build(:event_api, :online_event) }

    include_examples "regular teaching event"
  end

  describe "viewing a school or university event" do
    let(:event) { build(:event_api, :school_or_university_event) }

    include_examples "regular teaching event"
  end
end
