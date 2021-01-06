require "rails_helper"

describe "View events by category" do
  include_context "stub types api"

  let(:expected_limit) { EventsController::MAXIMUM_EVENTS_IN_CATEGORY }

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

  context "when viewing a category archive" do
    let(:category) { "online-events" }
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type) { events_by_type }
      get event_category_archive_events_path(category)
    end

    subject { response }

    it { is_expected.to have_http_status :success }
    it { expect(response.body).to include "Past Online Events" }

    context "when the category does not support archives" do
      let(:category) { "train-to-teach-events" }

      it { is_expected.to have_http_status :not_found }
    end
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
    let(:start_after) { DateTime.now.utc.beginning_of_day }
    let(:start_before) { start_after.advance(months: 5).end_of_month }
    let(:blank_search) { { postcode: nil, quantity_per_type: nil, radius: nil, start_after: start_after, start_before: start_before, type_id: nil } }

    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type).with(blank_search.merge(type_id: type_id, quantity_per_type: expected_limit))
      get event_category_events_path("school-and-university-events")
    end
  end

  describe "filtering the results" do
    let(:postcode) { "TE57 1NG" }
    let(:radius) { 30 }
    let(:start_after) { DateTime.now.utc.beginning_of_day }
    let(:start_before) { start_after.advance(months: 5).end_of_month }
    let(:filter) { { postcode: "TE57 1NG", quantity_per_type: nil, radius: radius, start_after: start_after, start_before: start_before, type_id: nil } }

    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type).with(filter.merge(type_id: type_id, quantity_per_type: expected_limit))
      get event_category_events_path("school-and-university-events", events_search: { distance: radius, postcode: postcode })
    end
  end

  describe "pagination" do
    before { get(path) }

    let(:events_per_page) { EventsController::EVENTS_PER_PAGE }
    let(:parsed_response) { Nokogiri.parse(response.body) }

    context "when there are more than one page's worth of events" do
      let(:extra_events) { 3 }
      let(:path) { event_category_events_path("train-to-teach-events") }
      let(:events) { build_list(:event_api, events_per_page + extra_events) }

      describe "pagination links" do
        specify "only the first page of events is shown" do
          expect(parsed_response.css(".event-box")).to have_attributes(size: 9)
        end

        specify "the navigation links should be visible" do
          expect(parsed_response.css("nav.pagination")).to be_present
        end

        specify "there should be a link to page 2 and a next link" do
          links = parsed_response.css("nav.pagination a")
          expect(links).to have_attributes(size: 2)

          %w[2 Next].each.with_index do |expected_link, i|
            expect(links[i].text).to match(expected_link)
          end
        end
      end

      describe "accessing later pages" do
        let(:path) { event_category_events_path("train-to-teach-events", page: 2) }

        specify "only the first page of events is shown" do
          expect(parsed_response.css(".event-box")).to have_attributes(size: extra_events)
        end
      end
    end

    context "when there are fewer than one page's worth of events" do
      let(:path) { event_category_events_path("train-to-teach-events") }
      let(:events) { build_list(:event_api, events_per_page - 3) }

      specify "no pagination links are shown" do
        expect(parsed_response.css("nav.pagination")).to be_empty
      end
    end

    context "when there are no results" do
      let(:path) { event_category_events_path("train-to-teach-events") }
      let(:events) { [] }

      subject { parsed_response.css(".no-results").first }

      it { is_expected.not_to be_nil }
      it { expect(subject.text).to include("Sorry your search has not found any events") }
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
