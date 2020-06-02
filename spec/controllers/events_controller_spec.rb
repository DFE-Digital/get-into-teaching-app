require "rails_helper"

describe EventsController, type: :request do
  include_context "stub types api"

  describe "#index" do
    let(:first_id) { SecureRandom.uuid }
    let(:second_id) { SecureRandom.uuid }

    let(:events) do
      [
        {
          eventId: first_id,
          readableEventId: first_id,
          eventName: "First",
          description: "first",
          startDate: "2020-05-20",
        },
        {
          eventId: second_id,
          readableEventId: second_id,
          eventName: "Second",
          description: "second",
          startDate: "2020-05-21",
        },
      ]
    end

    before do
      allow_any_instance_of(GetIntoTeachingApi::UpcomingEvents).to \
        receive(:data).and_return events
    end

    subject do
      get(events_path)
      response
    end

    it { is_expected.to have_http_status :success }
    it { is_expected.to have_rendered "index" }
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
      it { is_expected.to have_rendered "index" }
      it { is_expected.to have_attributes media_type: "text/html" }
    end

    context "with invalid search params" do
      let(:search_params) { { "distance" => "" } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_rendered "index" }
      it { is_expected.to have_attributes media_type: "text/html" }
    end
  end

  describe "#show" do
    let(:event_id) { SecureRandom.uuid }

    let(:event) do
      {
        eventId: event_id,
        readableEventId: event_id,
        eventName: "First",
        description: "first",
        startDate: "2020-05-20",
      }
    end

    subject do
      get(event_path(event_id))
      response
    end

    context "for known event" do
      before do
        allow_any_instance_of(GetIntoTeachingApi::Event).to \
          receive(:data).and_return event
      end

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_rendered "show" }
    end

    xcontext "for unknown event" do
      before do
        allow_any_instance_of(GetIntoTeachingApi::Event).to \
          receive(:data).and_raise Faraday::ResourceNotFound.new(nil)
      end

      it { is_expected.to have_http_status :not_found }
    end
  end
end
