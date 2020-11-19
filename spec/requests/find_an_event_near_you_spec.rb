require "rails_helper"

describe "Find an event near you" do
  include_context "stub types api"

  NO_EVENTS_REGEX = /Sorry your search has not found any events/.freeze

  let(:types) { Events::Search.available_event_type_ids }
  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_end_of_month - index.days
      type_id = types[index % types.count]
      build(:event_api, name: "Event #{index + 1}", start_at: start_at, type_id: type_id)
    end
  end
  let(:events_by_type) { events.group_by { |event| event.type_id.to_s.to_sym } }

  subject { response }

  context "when landing on the page initially" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:upcoming_teaching_events_indexed_by_type) { events_by_type }
    end

    before { get events_path }

    it { is_expected.to have_http_status :success }

    it "displays event types" do
      expect(response.body).to include("Types of Events")
      event_types = GetIntoTeachingApiClient::Constants::EVENT_TYPES.values

      event_types.each do |type|
        expect(response.body).to include(I18n.t("event_types.#{type}.description"))
      end
    end

    it "displays all events" do
      expect(response.body.scan(/Event [1-5]/).count).to eq(5)
    end

    it "presents the events in date order, per category" do
      headings = response.body.scan(/<h4>(.*)<\/h4>/).flatten.take(events.count)
      expect(headings).to eq(["Event 4", "Event 1", "Event 5", "Event 2", "Event 3"])
    end

    context "when there are no results" do
      let(:events) { [] }

      it "displays a single no results message" do
        no_results_messages = response.body.scan(NO_EVENTS_REGEX).flatten
        expect(no_results_messages.count).to eq(1)
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
          "School and University Events",
        ]

        expect(headings & expected_headings).to eq(expected_headings)
      end
    end
  end

  context "when searching for an event by type" do
    let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"] }
    let(:events) { [build(:event_api, type_id: type_id)] }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type) { events_by_type }
    end

    before { get search_events_path(events_search: { type: type_id, month: "2020-07" }) }

    it "displays only the category filtered to" do
      headings = response.body.scan(/<h3>(.*)<\/h3>/).flatten
      expected_headings = ["Train to Teach Events"]

      expect(headings).to eq(expected_headings)
    end

    context "when there are no results" do
      let(:events) { [] }

      it "displays a single no results message" do
        no_results_messages = response.body.scan(NO_EVENTS_REGEX).flatten
        expect(no_results_messages.count).to eq(1)
      end

      it "does not display any categories" do
        headings = response.body.scan(/<h3>(.*)<\/h3>/).flatten
        expect(headings).to be_empty
      end
    end
  end

  context "when searching for an event" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type) { events_by_type }
    end

    before { get search_events_path(events_search: { month: "2020-07" }) }

    it "displays events" do
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

      it "displays a single no results message" do
        no_results_messages = response.body.scan(NO_EVENTS_REGEX).flatten
        expect(no_results_messages.count).to eq(1)
      end
    end

    context "when there are results for a subset of categories" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }
      let(:events) { [build(:event_api, type_id: type_id)] }

      it "displays the no results message per category" do
        headings = response.body.scan(/<h3>(.*)<\/h3>/).flatten
        no_results_messages = response.body.scan(NO_EVENTS_REGEX).flatten
        expect(headings.count).to eq(Events::Search.available_event_types.count)
        expect(headings.count - 1).to eq(no_results_messages.count)
      end
    end
  end
end
