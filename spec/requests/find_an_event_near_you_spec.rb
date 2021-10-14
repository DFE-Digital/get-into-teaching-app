require "rails_helper"

xdescribe "Find an event near you", type: :request do
  include_context "with stubbed types api"

  subject { response }

  let(:no_events_regex) { /Sorry your search has not found any events/ }
  let(:no_ttt_events_regex) { /There are no Train to Teach events in your chosen month/ }
  let(:category_headings_regex) { /<h3>(Train to Teach events|Online Q&amp;As|School and University events)<\/h3>/ }
  let(:types) { Events::Search.available_event_type_ids }
  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_end_of_month - index.days
      type_id = types[index % types.count]
      build(:event_api, name: "Event #{index + 1}", start_at: start_at, type_id: type_id)
    end
  end
  let(:events_by_type) { group_events_by_type(events) }

  context "when landing on the page initially" do
    let(:expected_request_attributes) { { start_after: DateTime.now.utc.beginning_of_day } }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type)
        .with(a_hash_including(expected_request_attributes)) { events_by_type }
      get events_path
    end

    it { is_expected.to have_http_status :success }

    it "displays the submit an event section" do
      expect(response.body).to include("Do you have a teaching event?")
    end

    it "displays all events" do
      expect(response.body.scan(/Event [1-5]/).count).to eq(5)
    end

    it "presents the events in date order, per category" do
      headings = response.body.scan(/<h4>Event (.*)<\/h4>/).flatten.take(events.count)
      expect(headings).to eq(%w[4 1 5 2 3])
    end

    context "when there are events of different types" do
      let(:events) do
        GetIntoTeachingApiClient::Constants::EVENT_TYPES.values.map do |type_id|
          build(:event_api, start_at: DateTime.now, type_id: type_id)
        end
      end

      it "presents the types in the correct order" do
        headings = response.body.scan(category_headings_regex).flatten
        expected_headings = [
          "Train to Teach events",
          "Online Q&amp;As",
          "School and University events",
        ]

        expect(headings & expected_headings).to eq(expected_headings)
      end
    end
  end

  context "when searching for an event by type" do
    let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"] }
    let(:events) { [build(:event_api, type_id: type_id)] }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type) { events_by_type }
      get search_events_path(events_search: { type: type_id, month: "2020-07" })
    end

    it "displays only the category filtered to" do
      headings = response.body.scan(category_headings_regex).flatten
      expected_headings = ["Online Q&amp;As"]

      expect(headings).to eq(expected_headings)
    end

    it "displays the submit an event section" do
      expect(response.body).to include("Do you have a teaching event?")
    end

    context "when there are no results" do
      let(:events) { [] }

      context "when event type is Train to Teach" do
        let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"] }

        it "displays a single no results message" do
          no_results_messages = response.body.scan(no_ttt_events_regex).flatten
          expect(no_results_messages.count).to eq(1)
        end

        it "displays the link to sign up for notifications" do
          sign_up_button = response.body.scan(/Sign up for notifications/)
          expect(sign_up_button).to include("Sign up for notifications")
        end

        it "does not display any categories" do
          headings = response.body.scan(category_headings_regex).flatten
          expect(headings).to be_empty
        end
      end

      context "when event type is not Train to Teach" do
        it "displays a single no results message" do
          no_results_messages = response.body.scan(no_events_regex).flatten
          expect(no_results_messages.count).to eq(1)
        end

        it "does not display any categories" do
          headings = response.body.scan(category_headings_regex).flatten
          expect(headings).to be_empty
        end
      end
    end
  end

  context "when searching for an event" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type) { events_by_type }
      get search_events_path(events_search: { month: "2020-07" })
    end

    it "displays events" do
      expect(response.body.scan(/Event \d/).count).to eq(events.count)
    end

    it "does not display the events moved online notice" do
      expect(response.body).not_to include("Some events have moved online")
    end

    it "does not display the discover events heading" do
      expect(response.body).not_to include("Discover events")
    end

    it "categorises the results" do
      headings = response.body.scan(category_headings_regex).flatten
      expected_headings = [
        "Train to Teach events",
      ]

      expect(headings & expected_headings).to eq(expected_headings)
    end

    context "when there are no results" do
      let(:events) { [] }

      it "displays a single no results message" do
        no_results_messages = response.body.scan(no_events_regex).flatten
        expect(no_results_messages.count).to eq(1)
      end
    end

    context "when there are results for a subset of categories" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"] }
      let(:events) { [build(:event_api, type_id: type_id)] }

      it "displays the no results message per category" do
        headings = response.body.scan(category_headings_regex).flatten
        no_results_messages = response.body.scan(no_events_regex).flatten
        expect(headings.count).to eq(Events::Search.available_event_types.count)
        expect(headings.count - 2).to eq(no_results_messages.count)
      end

      it "displays the no TTT results message in the TTT category" do
        no_results_messages = response.body.scan(no_ttt_events_regex).flatten
        expect(no_results_messages.count).to eq(1)
      end
    end
  end
end
