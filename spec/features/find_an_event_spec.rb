require "rails_helper"

RSpec.feature "Finding an event", type: :feature do
  include_context "stub types api"

  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_beginning_of_month + index.days
      build(:event_api, name: "Event #{index + 1}", start_at: start_at)
    end
  end
  let(:event) { events.last }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events) { events }
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { event }
  end

  scenario "Finding an event by the list of featured events" do
    visit events_path

    expect(page).to have_text "Search for events"
    expect(page).to have_css "h2", text: "Organised by Get into Teaching"
    expect(page).to have_css "h2", text: "All events"

    click_on(event.name)

    expect(page).to have_css "h1", text: event.name
    click_on "Sign up for this event"
  end

  scenario "Finding an event by type" do
    visit events_path

    expect(page).to have_text "Search for events"

    select "Train to Teach event"
    click_on "Update results"

    expect(page).not_to have_css "h2", text: "Organized by Get into Teaching"
    expect(page).not_to have_css "h2", text: "All events"

    click_on(event.name)

    expect(page).to have_css "h1", text: event.name
    click_on "Sign up for this event"
  end
end
