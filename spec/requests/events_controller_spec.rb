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

      context "event information" do
        subject { response.body }

        it { is_expected.to include(event.name) }
        it { is_expected.to include(event.description) }
        it { is_expected.to include(event.message) }
        it { is_expected.to include(event.building.venue) }
        it { is_expected.to match(/iframe.+src="#{event.video_url}"/) }
        it { is_expected.to include(event.provider_website_url) }
        it { is_expected.to include(event.provider_target_audience) }
        it { is_expected.to include(event.provider_organiser) }
        it { is_expected.to match(/mailto:#{event.provider_contact_email}/) }
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
