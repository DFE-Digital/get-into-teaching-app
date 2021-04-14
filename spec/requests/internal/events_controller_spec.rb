require "rails_helper"

describe Internal::EventsController do
  let(:pending_event) do
    build(:event_api,
          :with_provider_info,
          name: "Pending event",
          status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
          type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
          is_virtual: nil,
          video_url: nil,
          message: nil,
          web_feed_id: nil)
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
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { pending_event }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:author)
        end
        it "shows pending events" do
          assert_response :success
          expect(response.body).to include("This is a pending event")
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

    context "when author user type" do
      context "when the event is pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { pending_event }

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
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { pending_event }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers(:publisher)
        end
        it "should have a final submit button" do
          assert_response :success
          expect(response.body).to include "Submit this provider event"
        end
      end
    end
  end

  describe "#new" do
    context "when any user type" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
          .to receive(:get_teaching_event_buildings) { [] }

        get new_internal_event_path, headers: generate_auth_headers(:author)
      end

      it "should have an events form" do
        assert_response :success
        expect(response.body).to include("form")
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
          .to receive(:get_teaching_event).with(event_to_edit_readable_id) { pending_event }

        get edit_internal_event_path(event_to_edit_readable_id), headers: generate_auth_headers(:author)
      end

      it "should have an events form with populated fields" do
        assert_response :success
        expect(response.body).to include("value=\"Pending event\"")
      end
    end
  end

  describe "#create" do
    context "when any user type" do
      let(:building_id) { pending_event.building.id }
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
        it "should post the event and an existing building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_event.building] }

          expected_request_body.building =
            build(:event_building_api, { id: params[:building][:id] })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers(:author),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end

      context "when \"select a venue\" is selected and a venue has not been chosen" do
        let(:params) do
          attributes_for :internal_event,
                         { "venue_type": Internal::Event::VENUE_TYPES[:existing], "building": { "id": "" } }
        end
        it "should post no building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_event.building] }

          expected_request_body.building = nil

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers(:author),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end

      context "when \"no venue\" is selected" do
        let(:params) do
          attributes_for :internal_event,
                         { "venue_type": Internal::Event::VENUE_TYPES[:none] }
        end
        it "should post no building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_event.building] }

          expected_request_body.building = nil

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers(:author),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
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
        it "should post new building fields with no id" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [pending_event.building] }

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

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end
    end
  end

  describe "#approve" do
    context "when publisher user type" do
      let(:event) { pending_event }
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

        it "should post the event with event status open" do
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

        it "should post the event with event status open" do
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
