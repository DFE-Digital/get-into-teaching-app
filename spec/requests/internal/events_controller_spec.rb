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

  before { events[0].status_id = 222_750_003 }

  describe "#index" do
    context "when any user type" do
      context "when there are no pending events" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { [] }

          get internal_events_path, headers: generate_auth_headers("author")
        end
        it "shows a no events banner" do
          assert_response :success
          expect(response.body).to include("No pending events")
        end
      end

      context "when there are pending events" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:search_teaching_events_grouped_by_type) { events_by_type }

          get internal_events_path, headers: generate_auth_headers("author")
        end
        it "shows pending events" do
          assert_response :success
          expect(response.body).not_to include("No pending events")
          expect(response.body).to include("<h4>Event 1</h4>")
          expect(response.body).not_to include("<h4>Event 2</h4>")
        end
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        get internal_events_path, headers: generate_auth_headers("wrong")

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        get internal_events_path

        assert_response :unauthorized
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

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers("author")
        end
        it "shows pending events" do
          assert_response :success
          expect(response.body).to include("This is a pending event")
          expect(response.body).to include("<h1>Event 1</h1>")
        end
      end

      context "when the event is not pending" do
        before do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { events[1] }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers("author")
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
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { events[0] }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers("author")
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
            .to receive(:get_teaching_event).with(event_to_get_readable_id) { events[0] }

          get internal_event_path(event_to_get_readable_id), headers: generate_auth_headers("publisher")
        end
        it "should have a final submit button" do
          assert_response :success
          expect(response.body).to include "Submit this provider event"
        end
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        get internal_event_path(event_to_get_readable_id, headers: generate_auth_headers("wrong"))

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        get internal_event_path(event_to_get_readable_id)

        assert_response :unauthorized
      end
    end
  end

  describe "#new" do
    context "when any user type" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
          .to receive(:get_teaching_event_buildings) { [] }

        get new_internal_event_path, headers: generate_auth_headers("author")
      end

      it "should have an events form" do
        assert_response :success
        expect(response.body).to include("form")
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        get new_internal_event_path, headers: generate_auth_headers("wrong")

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        get new_internal_event_path

        assert_response :unauthorized
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
          .to receive(:get_teaching_event).with(event_to_edit_readable_id) { events[0] }

        get edit_internal_event_path(event_to_edit_readable_id), headers: generate_auth_headers("author")
      end

      it "should have an events form with populated fields" do
        assert_response :success
        expect(response.body).to include("value=\"Event 1\"")
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        get edit_internal_event_path(event_to_edit_readable_id), headers: generate_auth_headers("wrong")

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        get edit_internal_event_path(event_to_edit_readable_id)

        assert_response :unauthorized
      end
    end
  end

  describe "#create" do
    context "when any user type" do
      let(:building_id) { events[0].building.id }
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
              provider_website_url: params[:provider_website_url])
      end

      context "when \"select a venue\" is selected" do
        let(:params) do
          attributes_for :internal_event,
                         { "building": { "id": building_id, "venue_type": "existing" } }
        end
        it "should post the event and an existing building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [events[0].building] }

          expected_request_body.building =
            build(:event_building_api, { id: params[:building][:id] })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers("author"),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end

      context "when \"no venue\" is selected" do
        let(:params) do
          attributes_for :internal_event,
                         { "building": { "venue_type": "none" } }
        end
        it "should post no building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [events[0].building] }

          expected_request_body.building = nil

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers("author"),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end

      context "when \"add a building\" is selected" do
        let(:expected_venue) { "New venue" }
        let(:params) do
          attributes_for :internal_event,
                         { "building":
                             { "id": building_id,
                               "venue": expected_venue,
                               "venue_type": "add" } }
        end
        it "should post new building fields with no id" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [events[0].building] }

          expected_request_body.building =
            build(:event_building_api, {
              id: nil,
              venue: expected_venue,
              address_line1: nil,
              address_line2: nil,
              address_line3: nil,
              address_city: nil,
              address_postcode: nil,
            })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          post internal_events_path,
               headers: generate_auth_headers("author"),
               params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        post internal_events_path,
             headers: generate_auth_headers("wrong")

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        post internal_events_path

        assert_response :unauthorized
      end
    end
  end

  describe "#update" do
    context "when any user type" do
      let(:building_id) { events[0].building.id }
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
              provider_website_url: params[:provider_website_url])
      end

      context "when \"select a venue\" is selected" do
        let(:params) do
          attributes_for :internal_event,
                         { "building": { "id": building_id, "venue_type": "existing" } }
        end
        it "should post the event and an existing building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [events[0].building] }

          expected_request_body.building =
            build(:event_building_api, { id: params[:building][:id] })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          put internal_event_path(expected_request_body.readable_id),
              headers: generate_auth_headers("author"),
              params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end

      context "when \"no venue\" is selected" do
        let(:params) do
          attributes_for :internal_event,
                         { "building": { "venue_type": "none" } }
        end
        it "should post no building" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [events[0].building] }

          expected_request_body.building = nil

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          put internal_event_path(expected_request_body.readable_id),
              headers: generate_auth_headers("author"),
              params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end

      context "when \"add a building\" is selected" do
        let(:expected_venue) { "New venue" }
        let(:params) do
          attributes_for :internal_event,
                         { "building":
                             { "id": building_id,
                               "venue": expected_venue,
                               "venue_type": "add" } }
        end
        it "should post new building fields with no id" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [events[0].building] }

          expected_request_body.building =
            build(:event_building_api, {
              id: nil,
              venue: expected_venue,
              address_line1: nil,
              address_line2: nil,
              address_line3: nil,
              address_city: nil,
              address_postcode: nil,

            })

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          put internal_event_path(expected_request_body.readable_id),
              headers: generate_auth_headers("author"),
              params: { internal_event: params }

          expect(response).to redirect_to(internal_events_path(success: :pending))
        end
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        put internal_event_path("any"),
            headers: generate_auth_headers("wrong")

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        put internal_event_path("any")

        assert_response :unauthorized
      end
    end
  end

  describe "#approve" do
    context "when any user type" do
      let(:event) { events[0] }
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
              provider_website_url: event.provider_website_url)
      end

      context "when event has no building" do
        let(:params) { { "format": event.id } }

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
              headers: generate_auth_headers("author"),
              params: params

          expect(response).to redirect_to(internal_events_path(success: true))
        end
      end

      context "when event has a building" do
        let(:params) { { "format": event.id } }

        it "should post the event with event status open" do
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:get_teaching_event).with(event.id) { event }
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
            .to receive(:get_teaching_event_buildings) { [] }

          expected_request_body.building = event.building

          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).with(expected_request_body)

          put internal_approve_path,
              headers: generate_auth_headers("author"),
              params: params

          expect(response).to redirect_to(internal_events_path(success: true))
        end
      end
    end

    context "when unauthenticated" do
      it "should reject bad login" do
        put internal_approve_path("any"), headers: generate_auth_headers("wrong")

        assert_response :unauthorized
      end

      it "should reject no authentication" do
        put internal_approve_path("any")

        assert_response :unauthorized
      end
    end
  end

private

  def generate_auth_headers(user_type)
    if user_type == "publisher"
      username = ENV["PUBLISHER_USERNAME"]
      password = ENV["PUBLISHER_PASSWORD"]
    elsif user_type == "author"
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
