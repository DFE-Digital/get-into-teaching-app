require "rails_helper"

describe EventsController do
  include_context "stub types api"

  describe "#index" do
    include_context "stub upcoming events by category api", EventsController::UPCOMING_EVENTS_PER_TYPE
    let(:parsed_response) { Nokogiri.parse(response.body) }
    let(:expected_description) { "Get your questions answered at an event." }

    subject! do
      get(events_path)
      response
    end

    it { is_expected.to have_http_status :success }

    it "has a meta description" do
      actual_description = parsed_response.at_css("head meta[name='description']")["content"]

      expect(actual_description).to eql(expected_description)
    end

    it "has a meta og:description" do
      actual_description = parsed_response.at_css("head meta[name='og:description']")["content"]

      expect(actual_description).to eql(expected_description)
    end

    specify "all events should be rendered" do
      expect(parsed_response.css(".events-featured__list__item").count).to eql(events.count)
    end

    specify "rendering the see all events button" do
      expect(subject.body).to match(%r{explore train to teach events}i)
    end
  end

  describe "#search" do
    let(:results_per_type) { EventsController::MAXIMUM_EVENTS_PER_CATEGORY }
    let(:events) { [build(:event_api, name: "First"), build(:event_api, name: "Second")] }
    let(:events_by_type) { group_events_by_type(events) }
    let(:search_key) { Events::Search.model_name.param_key }
    let(:search_path) { search_events_path(search_key => search_params) }
    let(:date) { DateTime.now.utc }
    let(:search_month) { date.strftime("%Y-%m") }
    let(:parsed_response) { Nokogiri.parse(response.body) }

    before do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_grouped_by_type)
        .with(a_hash_including(expected_request_attributes)) { events_by_type }
    end

    subject! do
      get(search_path)
      response
    end

    context "with valid search params" do
      let(:event_type_name) { "School or University event" }
      let(:event_type) { GetIntoTeachingApiClient::Constants::EVENT_TYPES[event_type_name] }
      let(:search_params) do
        attributes_for(
          :events_search,
          type: event_type,
          month: search_month,
          distance: "",
        )
      end
      let(:expected_request_attributes) do
        {
          postcode: nil,
          quantity_per_type: results_per_type,
          radius: nil,
          start_after: date.beginning_of_day,
          start_before: date.end_of_month,
          type_ids: [event_type],
        }
      end
      let(:expected_description) { "Get your questions answered at an event." }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes media_type: "text/html" }

      it "renders all events" do
        expect(parsed_response.css(".events-featured__list__item").count).to eql(events.count)
      end

      it "has a meta description" do
        actual_description = parsed_response.at_css("head meta[name='description']")["content"]

        expect(actual_description).to eql(expected_description)
      end

      it "has a meta og:description" do
        actual_description = parsed_response.at_css("head meta[name='og:description']")["content"]

        expect(actual_description).to eql(expected_description)
      end
    end

    context "with invalid search params" do
      let(:search_params) { { "distance" => "", month: search_month } }
      let(:expected_request_attributes) { { radius: nil } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes media_type: "text/html" }
    end

    context "with no search params" do
      let(:search_params) { nil }
      let(:expected_request_attributes) { { type_ids: nil } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes media_type: "text/html" }
    end
  end

  describe "#show" do
    let(:event_readable_id) { "123" }

    let(:event) do
      build(:event_api, :with_provider_info, readable_id: event_readable_id)
    end

    subject { response }

    context "with known event" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).and_return event

        get(event_path(id: event_readable_id))
      end

      it { is_expected.to have_http_status :success }

      describe "the response body" do
        subject { response.body }
        let(:parsed_response) { Nokogiri.parse(response.body) }

        it { is_expected.to include(event.name) }
        it { is_expected.to include(event.description) }
        it { is_expected.to include(event.message) }
        it { is_expected.to include(event.building.venue) }
        it { is_expected.to match(/#{event.building.address_line1}/) }
        it { is_expected.to match(/#{event.building.address_line2}/) }
        it { is_expected.to match(/#{event.building.address_postcode}/) }
        it { is_expected.to match(/iframe.+src="#{event.video_url}"/) }
        it { is_expected.to include(event.provider_website_url) }
        it { is_expected.to include(event.provider_target_audience) }
        it { is_expected.to include(event.provider_organiser) }
        it { is_expected.to match(/mailto:#{event.provider_contact_email}/) }
        it { is_expected.to include(event.building.image_url) }

        context "when the event can be registered for online" do
          let(:event) { build(:event_api, web_feed_id: "123", readable_id: event_readable_id) }

          it { is_expected.to match(/by registering you will receive information about what to expect/) }
          it { is_expected.to match(/Sign up for this event/) }

          context "when the event is online" do
            let(:event) { build(:event_api, :online, web_feed_id: "123", readable_id: event_readable_id) }

            it { is_expected.to match(/to access this event you will require a laptop\/desktop PC/) }
          end
        end

        context "when the event can be registered for by email" do
          let(:event) { build(:event_api, web_feed_id: nil, provider_contact_email: "test@email.com", readable_id: event_readable_id) }

          it { is_expected.to match(/To attend this event, please <a.*mailto.*email us.*a>/) }
        end

        context "when the event can be registered for via an external website" do
          let(:event) { build(:event_api, web_feed_id: nil, provider_website_url: "http://event.com", readable_id: event_readable_id) }

          it { is_expected.to match(/To attend this event, please <a.*visit this website.*a>/) }
        end

        context "when the event is closed" do
          let(:event) { build(:event_api, :closed, web_feed_id: "123", readable_id: event_readable_id) }

          it { is_expected.not_to match(/How to attend/) }
          it { is_expected.to match(/This event is now closed/) }
        end

        context "when the event has a scribble_id" do
          let(:event) { build(:event_api, scribble_id: "123", readable_id: event_readable_id) }

          it { is_expected.to match(/Attend online/) }
          it { is_expected.to match(/data-controller="scribble" data-scribble-id="123"/) }
        end

        context "when the event has a providers_list" do
          let(:event) { build(:event_api, providers_list: "<b><script type=\"malicious\"></script>a provider</b>", readable_id: event_readable_id) }

          it { is_expected.to match(/Training providers at this event/) }
          it { is_expected.to match(/<b>a provider<\/b>/) }
        end

        context "when the event is online" do
          let(:event) { build(:event_api, is_online: true) }

          it { is_expected.not_to match(/#{event.building.venue}/) }
          it { is_expected.not_to match(/#{event.building.address_line1}/) }
          it { is_expected.not_to match(/#{event.building.address_line2}/) }
          it { is_expected.not_to match(/#{event.building.address_postcode}/) }
        end

        context %(when the event is a 'School or University event') do
          let(:event) { build(:event_api, web_feed_id: nil, type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]) }

          it { is_expected.to match(%r{To register for this event, follow the instructions in the event information section}) }
          it { is_expected.not_to match(%r{Sign up for this}) }
        end

        context "when the event is a 'Pending event'" do
          let(:event) { build(:event_api, :pending, web_feed_id: nil) }

          it { expect(response).to have_http_status :success }
          it { expect(response.body).to include("Unfortunately, that event has already happened.") }
        end

        it "has a meta description" do
          actual_description = parsed_response.at_css("head meta[name='description']")["content"]

          expect(actual_description).to eql(event.summary)
        end

        it "has a meta og:description" do
          actual_description = parsed_response.at_css("head meta[name='og:description']")["content"]

          expect(actual_description).to eql(event.summary)
        end
      end
    end

    context "with unknown event" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).and_raise GetIntoTeachingApiClient::ApiError.new(code: 404)

        get(event_path(id: event_readable_id))
      end

      it { is_expected.to have_http_status :success }
      it { expect(response.body).to include("Unfortunately, that event has already happened.") }
    end
  end

  describe "redirects" do
    {
      "/events/category/some-event-category" => "/event-categories/some-event-category",
      "/event_categories/some-event-category" => "/event-categories/some-event-category",

      "/events/category/some-event-category/archive" => "/event-categories/some-event-category/archive",
      "/event_categories/some-event-category/archive" => "/event-categories/some-event-category/archive",
    }.each do |from, to|
      describe from do
        subject { get(from) }

        specify "redirects to #{to}" do
          expect(subject).to redirect_to(to)
        end
      end
    end
  end
end
