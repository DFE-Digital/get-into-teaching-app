require "rails_helper"

RSpec.xfeature "Finding an event", type: :feature do
  include_context "with stubbed types api"

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

  scenario "Landing on the find an event page and searching" do
    visit events_path

    expect(find_field("Event type").value).to be_empty # All events
    expect(find_field("Location").value).to be_empty # Nationwide
    expect(find_field("Month").value).to be_empty # All months

    click_on "Update results"

    expect(page.current_url).to include("/events/search")

    expect(page.current_url).to include("events_search[type]=")
    expect(page.current_url).to include("events_search[distance]=")
    expect(page.current_url).to include("events_search[postcode]=")
    expect(page.current_url).to include("events_search[month]=")
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

    expect(page).not_to have_css "h2", text: "Organized by Get Into Teaching"

    click_on(event.name)

    expect(page).to have_css "h1", text: event.name
    click_on "Sign up for this event", match: :first
  end

  scenario "Paging through search results" do
    visit events_path

    expect(page).to have_text "Search for events"
    expect(page).not_to have_css ".pagination"

    click_on "Update results"

    expect(page).to have_css ".pagination"

    # the pagination anchor is present
    expect(page).to have_css("#train-to-teach-events-list")

    # there are 11 events and 9 per page
    expect(page).to have_css(".event-box", count: 9)
    click_on("2")
    expect(page).to have_css(".event-box", count: 2)
  end

  scenario "Navigating events by page" do
    visit event_category_path(event_category_slug)

    expect(page).to have_css("h2", text: "Search for Train to Teach events")

    expect(page).to have_link("2", href: event_category_path(event_category_slug, page: 2, anchor: "event-category-list"))
    expect(page).to have_link("Next ›", href: event_category_path(event_category_slug, page: 2, anchor: "event-category-list"))

    # there are 11 events and 9 per page
    expect(page).to have_css(".event-box", count: 9)

    click_on("2")
    expect(page).to have_css(".event-box", count: 2)
    expect(page).to have_link("‹ Prev", href: event_category_path(event_category_slug, anchor: "event-category-list"))
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
