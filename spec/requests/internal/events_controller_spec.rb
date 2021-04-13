require "rails_helper"

describe Internal::EventsController do
  let(:pending_event) do
    build(:event_api,
          name: "Pending event",
          status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
          type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"])
  end
  let(:open_event) { build(:event_api, name: "Open event") }
  let(:events) { [pending_event, open_event] }
  let(:provider_events_by_type) { group_events_by_type([pending_event]) }

  describe "#index" do
    context "when any user type" do
      context "when there are no pending events" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { [] }

          get internal_events_path, headers: generate_auth_headers(:author)
        end
        it "shows a no events banner" do
          assert_response :success
          expect(response.body).to include("No pending events")
        end
      end

      context "when there are pending events" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { provider_events_by_type }

          get internal_events_path, headers: generate_auth_headers(:author)
        end
        it "shows pending events" do
          assert_response :success
          expect(response.body).not_to include("No pending events")
          expect(response.body).to include("<h4>Pending event</h4>")
          expect(response.body).not_to include("<h4>Open event</h4>")
        end
      end
    end
  end

  describe "#show" do
    let(:event_to_get_readable_id) { "1" }
    context "when any user type" do
      context "when the event is pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { events[0] }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:author)
        end
        it "shows pending events" do
          assert_response :success
          expect(response.body).to include("<h1>Pending event</h1>")
        end
      end

      context "when the event is not pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { events[1] }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:author)
        end
        it "redirects to not found" do
          assert_response :not_found
          expect(response.body).to include "Page not found"
        end
      end
    end
  end
end
