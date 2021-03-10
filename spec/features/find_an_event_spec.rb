require "rails_helper"

RSpec.feature "Finding an event", type: :feature do
  include_context "stub types api"

  let(:events) do
    11.times.collect do |index|
      start_at = Time.zone.today.at_beginning_of_month + index.days
      build(:event_api, name: "Event #{index + 1}", start_at: start_at)
    end
  end
  let(:events_by_type) { group_events_by_type(events) }
  let(:event) { events.first }
  let(:event_category_slug) { "train-to-teach-events" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { events_by_type }
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { event }
  end

  scenario "Finding an event by the list of featured events" do
    visit events_path

    expect(page).to have_text "Search for events"
    expect(page).to have_css "h3", text: "Train to Teach events"

    first(:link, event.name).click

    expect(page).to have_css "h1", text: event.name
    click_on "Sign up for this event", match: :first
  end

  scenario "Finding an event by type" do
    visit events_path

    expect(page).to have_text "Search for events"

    select "Train to Teach event"
    click_on "Update results"

    expect(page).not_to have_css "h2", text: "Organized by Get into Teaching"

    click_on(event.name)

    expect(page).to have_css "h1", text: event.name
    click_on "Sign up for this event", match: :first
  end

  scenario "Paging through search results" do
    visit events_path

    expect(page).to have_text "Search for events"
    expect(page).to_not have_css ".pagination"

    click_on "Update results"

    expect(page).to have_css ".pagination"

    # there are 11 events and 9 per page
    expect(page).to have_css(".event-box", count: 9)
    click_on("2")
    expect(page).to have_css(".event-box", count: 2)
  end

  scenario "Navigating events by page" do
    visit event_category_path(event_category_slug)

    expect(page).to have_css("h2", text: "Search for Train to Teach events")

    expect(page).to have_link("2", href: event_category_path(event_category_slug, page: 2))
    expect(page).to have_link("Next ›", href: event_category_path(event_category_slug, page: 2))

    # there are 11 events and 9 per page
    expect(page).to have_css(".event-box", count: 9)

    click_on("2")
    expect(page).to have_css(".event-box", count: 2)
    expect(page).to have_link("‹ Prev", href: event_category_path(event_category_slug))
  end

  scenario "Searching events within a category" do
    visit event_category_path("online-q-as")

    expect(page).to have_text "Search for Online Q&As"

    click_on "Update results"

    uri = URI.parse(page.current_url)
    expect(uri.fragment).to eq("searchforevents")

    within(:css, ".content-cta") do
      click_on "on this page"
    end

    expect(page).to have_text "Search for Past online Q&As"
  end
end
