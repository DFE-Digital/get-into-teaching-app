module Internal
  class EventsController < ::InternalController
    layout "internal"
    before_action :load_buildings, only: %i[new edit create]
    before_action :load_pending_events, only: %i[index]

    def index
      @no_results = @events.blank?

      @success = params[:success]
      @pending = params[:success] == "pending"
    end

    def show
      @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      raise_not_found unless @event.status_id == pending_event_status_id

      @page_title = @event.name
    end

    def new
      @event = Event.new(venue_type: Event::VENUE_TYPES[:existing])
      @event.building = EventBuilding.new
    end

    def approve
      render json: { error: "forbidden" }, status: :forbidden and return unless publisher?

      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      api_event.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"]
      submit_to_api(api_event)
      redirect_to internal_events_path(success: true)
    end

    def create
      @event = Event.new(event_params)
      @event.building = format_building(event_params)
      if submit_pending
        redirect_to internal_events_path(success: :pending)
      else
        render action: :new
      end
    end

    def edit
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      @event = Event.initialize_with_api_event(api_event)
      render :new
    end

  private

    def submit_pending
      return false if @event.invalid_with_building?

      @event.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
      api_event = @event.to_api_event
      submit_to_api(api_event)
    end

    def submit_to_api(body)
      GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(body)
      true
    rescue GetIntoTeachingApiClient::ApiError => e
      @event.map_api_errors_to_attributes(e) if e.code == 400
      false
    end

    def format_building(event_params)
      if event_params[:venue_type] == Event::VENUE_TYPES[:existing] && event_params[:building][:id].present?
        api_building = @buildings.find { |b| b.id == event_params[:building][:id] }
        return EventBuilding.initialize_with_api_building(api_building)
      end
      if event_params[:venue_type] == Event::VENUE_TYPES[:add]
        building = event_params[:building].to_hash
        building[:id] = nil # Id may be present on hidden field from previous selection
        return EventBuilding.new(building)
      end
      nil
    end

    def load_buildings
      @buildings = GetIntoTeachingApiClient::TeachingEventBuildingsApi
                     .new.get_teaching_event_buildings
    end

    def load_pending_events
      search_results = GetIntoTeachingApiClient::TeachingEventsApi
                         .new
                         .search_teaching_events_grouped_by_type(events_search_params)

      @group_presenter = Events::GroupPresenter.new(search_results)
      @events = @group_presenter.paginated_events_of_type(
        GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        params[:page],
      )
    end

    def events_search_params
      { type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        status_ids: [pending_event_status_id],
        quantity_per_type: 1_000 }
    end

    def pending_event_status_id
      GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
    end

    def event_params
      params.require(:internal_event).permit(
        :id,
        :name,
        :readable_id,
        :summary,
        :description,
        :is_online,
        :start_at,
        :end_at,
        :provider_contact_email,
        :provider_organiser,
        :provider_target_audience,
        :provider_website_url,
        :venue_type,
        building: %i[
          id
          venue
          address_line1
          address_line2
          address_line3
          address_city
          address_postcode
        ],
      )
    end
  end
end
