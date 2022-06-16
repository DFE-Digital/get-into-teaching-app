require "rails_helper"

RSpec.feature "Events near you promo", type: :feature do
  include_context "with stubbed types api"

  let(:beginning_of_month) { Time.zone.today.at_beginning_of_month }
  let(:events) { build_list(:event_api, 1) }
  let(:events_by_type) { group_events_by_type(events) }
  let(:event) { events.first }
  let(:postcode) { "M1" }
  let(:distance) { 10 }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { events_by_type }
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { event }
  end

  scenario "Starting a search from a promo" do
    visit page_path(page: "train-to-be-a-teacher/if-you-have-a-degree")
    fill_in "Enter postcode", with: "M1"
    click_on "event-search"

    current_url = CGI.unescape(page.current_url)
    expect(current_url).to include("/events")
    expect(current_url).to include("events_search[distance]=#{distance}")
    expect(current_url).to include("events_search[postcode]=#{Encryptor.encrypt(postcode)}")
  end
end
