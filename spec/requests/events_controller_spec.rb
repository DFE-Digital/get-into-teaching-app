require "rails_helper"

describe EventsController do
  include_context "stub types api"

  describe "#index" do
    let(:first_readable_id) { "123" }
    let(:second_readable_id) { "456" }

    let(:events) do
      [
        build(:event_api, readable_id: first_readable_id, name: "First"),
        build(:event_api, readable_id: second_readable_id, name: "Second"),
      ]
    end

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:search_teaching_events).and_return events
    end

    subject do
      get(events_path)
      response
    end

    it { is_expected.to have_http_status :success }
  end

  describe "#search" do
    let(:search_key) { Events::Search.model_name.param_key }
    let(:search_path) { search_events_path(search_key => search_params) }

    subject do
      get(search_path)
      response
    end

    context "with valid search params" do
      let(:search_params) { attributes_for :events_search }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes media_type: "text/html" }
    end

    context "with invalid search params" do
      let(:search_params) { { "distance" => "" } }

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
          receive(:get_teaching_event).and_raise GetIntoTeachingApiClient::ApiError

        get(event_path(id: event_readable_id))
      end

      it { is_expected.to have_http_status :not_found }
    end
  end
end
