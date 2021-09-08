require "rails_helper"

describe "View events by category", type: :request do
  include_context "with stubbed types api"

  let(:expected_limit) { EventCategoriesController::MAXIMUM_EVENTS_IN_CATEGORY }

  let(:events) do
    5.times.collect do |index|
      start_at = Time.zone.today.at_beginning_of_month + index.days
      build(:event_api, name: "Event #{index + 1}", start_at: start_at)
    end
  end
  let(:events_by_type) { group_events_by_type(events) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { events_by_type }
  end

  context "when viewing a category archive" do
    let(:category) { "online-q-as" }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type) { events_by_type }
      get archive_event_category_path(category)
    end

    subject { response }

    it { is_expected.to have_http_status :success }
    it { expect(response.body).to include "Past online Q&amp;As" }

    it "displays all events in the category, ordered by date descending" do
      expect(response.body.scan(/Event \d/)).to eq(["Event 5", "Event 4", "Event 3", "Event 2", "Event 1"])
    end

    context "when the category does not support archives" do
      let(:category) { "train-to-teach-events" }

      it { is_expected.to have_http_status :not_found }
    end
  end

  context "when viewing a category" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type) { events_by_type }
      get event_category_path("train-to-teach-events")
    end

    subject { response }

    it { is_expected.to have_http_status :success }

    it "displays all events in the category, ordered by date ascending" do
      expect(response.body.scan(/Event \d/)).to eq(["Event 1", "Event 2", "Event 3", "Event 4", "Event 5"])
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

  context "when viewing old online-events url" do
    subject { response }

    context "when current events" do
      before { get event_category_path "online-events" }

      it { is_expected.to redirect_to event_category_path "online-q-as" }
    end

    context "when archive events" do
      before { get archive_event_category_path "online-events" }

      it { is_expected.to redirect_to archive_event_category_path "online-q-as" }
    end
  end

  context "when viewing the schools and university events category" do
    let(:start_after) { DateTime.now.utc.beginning_of_day }
    let(:start_before) { start_after.advance(months: 24).end_of_month }
    let(:blank_search) { { postcode: nil, quantity_per_type: nil, radius: nil, start_after: start_after, start_before: start_before, type_ids: nil } }

    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type).with(blank_search.merge(type_ids: [type_id], quantity_per_type: expected_limit))
      get event_category_path("school-and-university-events")
    end
  end

  describe "filtering the results" do
    let(:postcode) { "TE57 1NG" }
    let(:radius) { 25 }
    let(:start_after) { DateTime.now.utc.beginning_of_day }
    let(:start_before) { start_after.advance(months: 24).end_of_month }
    let(:filter) { { postcode: "TE57 1NG", quantity_per_type: nil, radius: radius, start_after: start_after, start_before: start_before, type_ids: nil } }

    it "queries events for the correct category" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type).with(filter.merge(type_ids: [type_id], quantity_per_type: expected_limit))
      get event_category_path("school-and-university-events", events_search: { distance: radius, postcode: postcode })
    end
  end

  describe "pagination" do
    before { get(path) }

    let(:events_per_page) { Events::GroupPresenter::EVENTS_PER_TYPE }
    let(:parsed_response) { Nokogiri.parse(response.body) }

    context "when there are more than one page's worth of events" do
      let(:extra_events) { 3 }
      let(:path) { event_category_path("train-to-teach-events") }
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
        let(:path) { event_category_path("train-to-teach-events", page: 2) }

        specify "only the first page of events is shown" do
          expect(parsed_response.css(".event-box")).to have_attributes(size: extra_events)
        end
      end
    end

    context "when there are fewer than one page's worth of events" do
      let(:path) { event_category_path("train-to-teach-events") }
      let(:events) { build_list(:event_api, events_per_page - 3) }

      specify "no pagination links are shown" do
        expect(parsed_response.css("nav.pagination")).to be_empty
      end
    end

    context "when there are no results" do
      let(:path) { event_category_path("train-to-teach-events") }
      let(:events) { [] }

      subject { parsed_response.css(".no-results").first }

      it { is_expected.not_to be_nil }
      it { expect(subject.text).to include("Sorry your search has not found any events") }
    end
  end

  context "when a category does not exist" do
    before do
      get event_category_path("non-existant")
    end

    subject { response }

    it { is_expected.to have_http_status :not_found }
  end
end
