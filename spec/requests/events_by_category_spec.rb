require "rails_helper"

describe "View events by category" do
  include_context "stub types api"

  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_beginning_of_month + index.days
      build(:event_api, name: "Event #{index + 1}", start_at: start_at)
    end
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events) { events }
  end

  context "when viewing a category" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events) { events }
      get event_category_events_path("train-to-teach-events")
    end

    subject { response }

    it { is_expected.to have_http_status :success }

    it "displays all events in the category" do
      expect(response.body.scan(/Event \d/).count).to eq(events.count)
    end
  end

  context "when viewing the schools and university events category" do
    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events).with(type_id: type_id.to_s)
      get event_category_events_path("school-and-university-events")
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
