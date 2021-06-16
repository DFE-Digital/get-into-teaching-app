require "rails_helper"

describe Internal::EventsController do
  let(:pending_provider_event) do
    build(:event_api,
          :with_provider_info,
          name: "Pending provider event",
          status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
          type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
          is_virtual: nil,
          video_url: nil,
          message: nil,
          web_feed_id: nil)
  end
  let(:pending_online_event) do
    build(:event_api,
          :with_provider_info,
          name: "Pending online event",
          status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
          type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"],
          is_virtual: nil,
          video_url: nil,
          message: nil,
          web_feed_id: nil)
  end
  let(:open_event) { build(:event_api, name: "Open event") }
  let(:events) { [pending_provider_event, open_event, pending_online_event] }
  let(:provider_events_by_type) { group_events_by_type([pending_provider_event]) }
  let(:online_events_by_type) { group_events_by_type([pending_online_event]) }
  let(:publisher_username) { "publisher_username" }
  let(:publisher_password) { "publisher_password" }
  let(:author_username) { "author_username" }
  let(:author_password) { "author_password" }

  before do
    BasicAuth.class_variable_set(:@@credentials, nil)

    allow(Rails.application.config.x).to receive(:http_auth) do
      "#{publisher_username}|#{publisher_password}|publisher,#{author_username}|#{author_password}|author"
    end
  end

  describe "#index" do
    shared_examples "no pending events" do |event_type, default_event_type|
      context "when there are no pending #{event_type || default_event_type} events" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { [] }

          get internal_events_path, headers: generate_auth_headers(:author), params: { event_type: event_type }
        end
        it "shows a no events banner" do
          assert_response :success
          expect(response.body).to include("No pending events")
        end
      end
    end

    shared_examples "pending events" do |event_params, default_event_type|
      let(:event_type) { event_params }

      context "when there are pending #{event_params || default_event_type} events" do
        before do
          get internal_events_path, headers: generate_auth_headers(:author), params: event_type
        end

        it "shows pending #{event_params || default_event_type} events" do
          assert_response :success
          expect(response.body).not_to include("No pending events")
          expect(response.body).to include("<h4>Pending #{event_type || default_event_type} event</h4>")
          expect(response.body).not_to include("<h4>Open event</h4>")
        end
      end
    end

    context "when any user type" do
      include_examples "no pending events", "provider"

      include_examples "no pending events", "online"

      include_examples "pending events", "provider" do
        before(:each) do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { provider_events_by_type }
        end
      end

      include_examples "pending events", "online" do
        before(:each) do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { online_events_by_type }
        end
      end

      context "when no event type params are passed" do
        default_event_type = "provider".freeze

        include_examples "pending events", nil, default_event_type do
          before(:each) do
            allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
              .to receive(:search_teaching_events_grouped_by_type) { provider_events_by_type }
          end
        end

        include_examples "no pending events", default_event_type
      end
    end
  end

  describe "#show" do
    let(:event_to_get_readable_id) { "1" }
    context "when any user type" do
      context "when the event is pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { pending_provider_event }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:author)
        end
        it "shows pending events" do
          assert_response :success
          expect(response.body).to include("This is a pending event")
          expect(response.body).to include("<h1>Pending provider event</h1>")
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

    context "when author user type" do
      context "when the event is pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { pending_provider_event }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:author)
        end
        it "does not have a final submit button" do
          assert_response :success
          expect(response.body).to_not include "Submit this provider event"
        end
      end
    end

    context "when publisher user type" do
      context "when the event is pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { pending_provider_event }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:publisher)
        end
        it "has a final submit button" do
          assert_response :success
          expect(response.body).to include "Set event status to Open"
        end
      end
    end
  end

  describe "#new" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
        .to receive(:get_teaching_event_buildings) { [] }
    end

    shared_examples "new event" do |event_params|
      it "renders #{event_params || 'provider'} events form" do
        get new_internal_event_path, headers: generate_auth_headers(:author), params: { event_type: event_params }

        assert_response :success
        expect(response.body).to include("#{event_params ? event_params.capitalize : 'Provider'} event details")
      end
    end

    context "when any user type" do
      context "when event is duplicated" do
        let(:event_to_duplicate_readable_id) { "1" }
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [] }
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_duplicate_readable_id) { pending_online_event }
        end

        it "renders the events form with populated fields" do
          get new_internal_event_path(duplicate: event_to_duplicate_readable_id), headers: generate_auth_headers(:author)

          assert_response :success
          expect(response.body).to include("value=\"Pending online event\"")
        end

        it "removes 'id', 'partial url', 'start at' and 'end at' values" do
          get new_internal_event_path(duplicate: event_to_duplicate_readable_id), headers: generate_auth_headers(:author)

          assert_response :success
          expect(css_select("#internal_event_id").first[:value]).to be_nil
          expect(css_select("#internal-event-readable-id-field").first[:value]).to be_nil
          expect(css_select("#internal_event_start_at").first[:value]).to be_nil
          expect(css_select("#internal_event_end_at").first[:value]).to be_nil
        end
      end

      context "when no event type parameter" do
        include_examples "new event"
      end

      context "when provider event type parameter" do
        include_examples "new event", "provider"
      end

      context "when online event type parameter" do
        include_examples "new event", "online"
      end
    end
  end

  describe "#edit" do
    let(:event_to_edit_readable_id) { "1" }
    context "when any user type" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
          .to receive(:get_teaching_event_buildings) { [] }
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
          .to receive(:get_teaching_event).with(event_to_edit_readable_id) { pending_provider_event }

        get edit_internal_event_path(event_to_edit_readable_id), headers: generate_auth_headers(:author)
      end

      it "has an events form with populated fields" do
        assert_response :success
        expect(response.body).to include("value=\"Pending provider event\"")
      end
    end
  end

  describe "#create" do
    context "when any user type" do
      let(:building_id) { pending_provider_event.building.id }
      let(:expected_request_body) do
        build(:event_api,
              id: params[:id],
              name: params[:name],
              readable_id: params[:readable_id],
              type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
              status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
              summary: params[:summary],
              description: params[:description],
              is_online: params[:is_online],
              start_at: params[:start_at].getutc.floor,
              end_at: params[:end_at].getutc.floor,
              provider_contact_email: params[:provider_contact_email],
              provider_organiser: params[:provider_organiser],
              provider_target_audience: params[:provider_target_audience],
              provider_website_url: params[:provider_website_url],
              is_virtual: nil,
              video_url: nil,
              message: nil,
              web_feed_id: nil)
      end

      context "when \"select a venue\" is selected" do
        let(:params) do
          attributes_for :internal_event,
                         { "venue_type": Internal::Event::VENUE_TYPES[:existing], "building": { "id": building_id } }
        end
        it "posts the event and an existing building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_provider_event.building] }

          expected_request_body.building =
            build(:event_building_api, { id: params[:building][:id] })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers(:author),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending, readable_id: "Test"))
        end
      end

      context "when \"no venue\" is selected" do
        let(:params) do
          attributes_for(:internal_event, { "venue_type": Internal::Event::VENUE_TYPES[:none], "building": { "id": "" } })
        end
        it "does not post a building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_provider_event.building] }

          expected_request_body.building = nil

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers(:author),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending, readable_id: "Test"))
        end
      end

      context "when \"add a building\" is selected" do
        let(:expected_venue) { "New venue" }
        let(:expected_postcode) { "M1 7AX" }
        let(:params) do
          attributes_for :internal_event,
                         { "venue_type": Internal::Event::VENUE_TYPES[:add],
                           "building":
                             { "id": building_id,
                               "venue": expected_venue,
                               "address_postcode": expected_postcode } }
        end
        it "posts building with no id" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_provider_event.building] }

          expected_request_body.building =
            build(:event_building_api, {
              id: nil,
              venue: expected_venue,
              address_line1: nil,
              address_line2: nil,
              address_line3: nil,
              address_city: nil,
              address_postcode: expected_postcode,
            })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers(:author),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending, readable_id: "Test"))
        end
      end
    end
  end

  describe "#approve" do
    context "when publisher user type" do
      let(:event) { pending_provider_event }
      let(:expected_request_body) do
        build(:event_api,
              id: event.id,
              name: event.name,
              readable_id: event.readable_id,
              type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
              status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"],
              summary: event.summary,
              description: event.description,
              is_online: event.is_online,
              start_at: event.start_at,
              end_at: event.end_at,
              provider_contact_email: event.provider_contact_email,
              provider_organiser: event.provider_organiser,
              provider_target_audience: event.provider_target_audience,
              provider_website_url: event.provider_website_url,
              is_virtual: nil,
              video_url: nil,
              message: nil,
              web_feed_id: nil)
      end

      context "when event has no building" do
        let(:params) { { "id": event.id } }

        it "posts the event with event status open" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event.id) { event }
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [] }

          event.building = nil
          expected_request_body.building = nil

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          put internal_approve_path,
              headers: generate_auth_headers(:publisher),
              params: params

          expect(response).to redirect_to(internal_events_path(success: true))
        end
      end

      context "when event has a building" do
        let(:params) { { "id": event.id } }

        it "posts the event with event status open" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event.id) { event }
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [] }

          expected_request_body.building = event.building

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          put internal_approve_path,
              headers: generate_auth_headers(:publisher),
              params: params

          expect(response).to redirect_to(internal_events_path(success: true))
        end
      end
    end

    context "when author user type" do
      it "responds with forbidden" do
        put internal_approve_path, headers: generate_auth_headers(:author)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
