require "rails_helper"

describe Internal::EventsController do
  let(:types) { Events::Search.available_event_type_ids }
  let(:events) do
    2.times.collect do |index|
      start_at = Time.zone.today.at_end_of_month - index.days
      type_id = types[index % types.count]
      build(:event_api, :with_provider_info, name: "Event #{index + 1}", start_at: start_at, type_id: type_id)
    end
  end
  let(:events_by_type) { group_events_by_type(events) }
  let(:provider_events_by_type) { group_events_by_type([events[0]]) }

  before do
    events[0].status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
    events[0].type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]
  end

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
          expect(response.body).to include("<h4>Event 1</h4>")
          expect(response.body).not_to include("<h4>Event 2</h4>")
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
          expect(response.body).to include("<h1>Event 1</h1>")
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

private

  def generate_auth_headers(user_type)
    if user_type == :publisher
      username = ENV["PUBLISHER_USERNAME"]
      password = ENV["PUBLISHER_PASSWORD"]
    elsif user_type == :author
      username = ENV["AUTHOR_USERNAME"]
      password = ENV["AUTHOR_PASSWORD"]
    end

    { "HTTP_AUTHORIZATION" =>
        ActionController::HttpAuthentication::Basic.encode_credentials(
          username,
          password,
        ) }
  end
end
