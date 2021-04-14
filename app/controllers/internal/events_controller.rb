module Internal
  class EventsController < ::InternalController
    layout "internal"
    before_action :load_pending_events, only: %i[index]
    before_action :authorize_publisher, only: %i[approve]

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
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      api_event.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"]
      GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(api_event)
      redirect_to internal_events_path(success: true)
    end

    def create
      @event = Event.new(event_params)
      if @event.save
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

    def authorize_publisher
      render_forbidden unless publisher?
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
      {
        type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        status_ids: [pending_event_status_id],
        quantity_per_type: 1_000,
      }
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
