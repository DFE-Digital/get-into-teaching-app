require "rails_helper"

describe EventsController do
  include_context "stub types api"

  describe "#index" do
    let(:results_per_type) { Events::Search::RESULTS_PER_TYPE }
    let(:events) { [build(:event_api, name: "First"), build(:event_api, name: "Second")] }
    let(:events_by_type) { events.group_by { |event| event.type_id.to_s.to_sym } }
    let(:parsed_response) { Nokogiri.parse(response.body) }
    let(:expected_request_attributes) { { quantity_per_type: results_per_type } }

    before do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:upcoming_teaching_events_indexed_by_type)
        .with(a_hash_including(expected_request_attributes)) { events_by_type }
    end

    subject! do
      get(events_path)
      response
    end

    it { is_expected.to have_http_status :success }

    specify "all events should be rendered" do
      expect(parsed_response.css(".events-featured__list__item").count).to eql(events.count)
    end

    specify "rendering the see all events button" do
      expect(subject.body).to match(/see all train to teach events/i)
    end
  end

  describe "#search" do
    let(:results_per_type) { Events::Search::RESULTS_PER_TYPE }
    let(:events) { [build(:event_api, name: "First"), build(:event_api, name: "Second")] }
    let(:events_by_type) { events.group_by { |event| event.type_id.to_s.to_sym } }
    let(:search_key) { Events::Search.model_name.param_key }
    let(:search_path) { search_events_path(search_key => search_params) }
    let(:date) { 1.week.from_now }
    let(:search_month) { date.strftime("%Y-%m") }
    let(:parsed_response) { Nokogiri.parse(response.body) }

    before do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events_indexed_by_type)
        .with(a_hash_including(expected_request_attributes)) { events_by_type }
    end

    subject! do
      get(search_path)
      response
    end

    context "with valid search params" do
      let(:event_type_name) { "Train to Teach Event" }
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
          start_after: date.beginning_of_month,
          start_before: date.end_of_month,
          type_id: event_type,
        }
      end

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes media_type: "text/html" }

      specify "all events should be rendered" do
        expect(parsed_response.css(".events-featured__list__item").count).to eql(events.count)
      end
    end

    context "with invalid search params" do
      let(:search_params) { { "distance" => "", month: search_month } }
      let(:expected_request_attributes) { { radius: nil } }

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

    context "for known event" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).and_return event

        get(event_path(id: event_readable_id))
      end

      it { is_expected.to have_http_status :success }

      context "within the response body" do
        subject { response.body }

        context "event information" do
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
        end

        context "when the event can be registered for online" do
          let(:event) { build(:event_api, web_feed_id: "123", readable_id: event_readable_id) }

          it { is_expected.to match(/Sign up for this <span>event<\/span>/) }
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

          it { is_expected.to_not match(/How to attend/) }
          it { is_expected.to match(/This event is now closed/) }
        end

        context "when the event has a scribble_id" do
          let(:event) { build(:event_api, scribble_id: "123", readable_id: event_readable_id) }

          it { is_expected.to match(/Attend online/) }
          it { is_expected.to match(/data-controller="scribble" data-scribble-id="123"/) }
        end

        context "when the event is online" do
          let(:event) { build(:event_api, is_online: true) }

          it { is_expected.to_not match(/#{event.building.venue}/) }
          it { is_expected.to_not match(/#{event.building.address_line1}/) }
          it { is_expected.to_not match(/#{event.building.address_line2}/) }
          it { is_expected.to_not match(/#{event.building.address_postcode}/) }
        end

        context %(when the event is a 'School or University Event') do
          let(:event) { build(:event_api, web_feed_id: nil, type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]) }

          it { is_expected.to match(%r{To register for this event, follow the instructions in the event information section}) }
          it { is_expected.not_to match(%r{Sign up for this}) }
        end
      end
    end

    context "for unknown event" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:get_teaching_event).and_raise GetIntoTeachingApiClient::ApiError.new(code: 404)

        get(event_path(id: event_readable_id))
      end

      it { is_expected.to have_http_status :not_found }
    end
  end
end
