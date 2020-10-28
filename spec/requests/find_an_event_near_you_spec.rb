require "rails_helper"

describe "Find an event near you" do
  include_context "stub types api"

  NO_EVENTS_REGEX = /no events that match your search criteria/.freeze

  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_end_of_month - index.days
      build(:event_api, name: "Event #{index + 1}", start_at: start_at)
    end
  end
  let(:events_by_type) { events.group_by { |event| event.type_id.to_s.to_sym } }
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_indexed_by_type) { events_by_type }
  end

  subject { response }

  context "when landing on the page initially" do
    before { get events_path }

    it { is_expected.to have_http_status :success }

    it "displays all events" do
      expect(response.body.scan(/Event [1-5]/).count).to eq(5)
    end

    it "presents the events in date order" do
      headings = response.body.scan(/<h4>(.*)<\/h4>/).flatten.take(events.count)
      expect(headings).to eq(["Event 5", "Event 4", "Event 3", "Event 2", "Event 1"])
    end

    context "when there are no results" do
      let(:events) { [] }

      it "displays the no results message" do
        expect(response.body).to match(NO_EVENTS_REGEX)
      end
    end

    context "when there are events of different types" do
      let(:events) do
        GetIntoTeachingApiClient::Constants::EVENT_TYPES.values.map do |type_id|
          build(:event_api, start_at: DateTime.now, type_id: type_id)
        end
      end

      it "presents the types in the correct order" do
        headings = response.body.scan(/<h3>(.*)<\/h3>/).flatten
        expected_headings = [
          "Train to Teach Events",
          "Online Events",
          "Application Workshops",
          "School and University Events",
        ]

        expect(headings & expected_headings).to eq(expected_headings)
      end
    end
  end

  context "when searching for an event by type" do
    let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"] }
    before { get search_events_path(events_search: { type: type_id, month: "2020-07" }) }

    it "displays all events of that type" do
      expect(response.body.scan(/Event \d/).count).to eq(events.count)
    end

    it "categorises the results" do
      headings = response.body.scan(/<h3>(.*)<\/h3>/).flatten
      expected_headings = [
        "Train to Teach Events",
      ]

      expect(headings & expected_headings).to eq(expected_headings)
    end

    context "when there are no results" do
      let(:events) { [] }

      it "displays the no results message" do
        expect(response.body).to match(NO_EVENTS_REGEX)
      end
    end
  end
end
