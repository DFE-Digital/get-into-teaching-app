require "rails_helper"

describe "View events by category" do
  include_context "stub types api"

  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_beginning_of_month + index.days
      build(:event_api, name: "Event #{index + 1}", start_at: start_at)
    end
  end
  let(:events_by_type) { events.group_by { |event| event.type_id.to_s.to_sym } }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_indexed_by_type) { events_by_type }
  end

  context "when viewing a category" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type) { events_by_type }
      get event_category_events_path("train-to-teach-events")
    end

    subject { response }

    it { is_expected.to have_http_status :success }

    it "displays all events in the category" do
      expect(response.body.scan(/Event \d/).count).to eq(events.count)
    end

    it "does not display the 'See all events' button" do
      expect(response.body.scan(/see all train to teach events/i)).to be_empty
    end

    it "displays an event filter" do
      expect(response.body).to match(/Search for train to teach events/i)
    end

    it "hides the type field" do
      expect(response.body).not_to match(/Event type/i)
    end
  end

  context "when viewing the schools and university events category" do
    let(:blank_search) { { postcode: nil, quantity_per_type: nil, radius: nil, start_after: nil, start_before: nil, type_id: nil } }

    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type).with(blank_search.merge(type_id: type_id, quantity_per_type: 1_000))
      get event_category_events_path("school-and-university-events")
    end
  end

  context "filtering the results" do
    let(:postcode) { "TE57 ING" }
    let(:radius) { 30 }
    let(:filter) { { postcode: postcode, quantity_per_type: nil, radius: radius, start_after: nil, start_before: nil, type_id: nil } }

    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type).with(filter.merge(type_id: type_id, quantity_per_type: 1_000))
      get event_category_events_path("school-and-university-events", events_search: { distance: radius, postcode: postcode })
    end
  end

  context "when a category does not exist" do
    before do
      get event_category_events_path("non-existant")
    end

    subject { response }

    it { is_expected.to have_http_status :not_found }
  end
end
