module Internal
  class EventsController < ::InternalController
    layout "internal"
    before_action :authorize_publisher, only: %i[approve withdraw]
    helper_method :event_type_name

    DEFAULT_EVENT_TYPE = "provider".freeze
    NILIFY_ON_DUPLICATE = %i[id readable_id start_at end_at].freeze

    def index
      @event_type = determine_event_type_from_name(params[:event_type])

      load_pending_events(@event_type)
      @no_results = @events.blank?

      @status = params[:status]
      @readable_id = params[:readable_id]
    end

    def show
      @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      raise_not_found unless @event.status_id == pending_event_status_id

      @page_title = @event.name
    end

    def new
      if params[:duplicate]
        @event = get_event_by_id(params[:duplicate])
        @event.assign_attributes(NILIFY_ON_DUPLICATE.to_h { |attribute| [attribute, nil] })
      else
        @event_type = determine_event_type_from_name(params[:event_type])
        @event = Event.new(venue_type: Event::VENUE_TYPES[:existing], type_id: @event_type)
        @event.building = EventBuilding.new
      end
    end

    def approve
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      api_event.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"]
      GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(api_event)
      Rails.logger.info("#{@user.username} - publish - #{api_event.to_json}")
      redirect_to internal_events_path(
        status: :published,
        event_type: determine_event_type_from_id(api_event.type_id),
        readable_id: api_event.readable_id,
      )
    end

    def withdraw
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      api_event.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
      GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(api_event)
      Rails.logger.info("#{@user.username} - withdrawn - #{api_event.to_json}")
      redirect_to internal_events_path(
        status: :withdrawn,
        event_type: determine_event_type_from_id(api_event.type_id),
        readable_id: api_event.readable_id,
      )
    end

    def open_events
      events = GetIntoTeachingApiClient::TeachingEventsApi
                 .new
                 .search_teaching_events_grouped_by_type(quantity_per_type: 1_000,
                                                         start_after: DateTime.now.utc.beginning_of_day,
                                                         status_ids: [open_event_status_id])

      events = events.select do |key|
        key.type_id == event_types[:provider] || key.type_id == event_types[:online]
      end
      @open_events = events.map(&:teaching_events).flatten
    end

    def create
      @event = Event.new(event_params)
      @event.assign_building(building_params) unless @event.online_event?

      if @event.save
        Rails.logger.info("#{@user.username} - create/update - #{@event.to_api_event.to_json}")
        redirect_to internal_events_path(
          status: :pending,
          readable_id: @event.readable_id,
          event_type: determine_event_type_from_id(@event.type_id),
        )
      else
        render action: :new
      end
    end

    def edit
      @event = get_event_by_id(params[:id])

      render :new
    end

  private

    def determine_event_type_from_name(type_name)
      event_types[type_name] || event_types[:provider]
    end

    def determine_event_type_from_id(type_id)
      event_types.key(type_id).to_s
    end

    def event_type_name
      params[:event_type] || DEFAULT_EVENT_TYPE
    end

    def get_event_by_id(event_id)
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(event_id)
      @event = Event.initialize_with_api_event(api_event)
    end

    def authorize_publisher
      render_forbidden unless @user.publisher?
    end

    def load_pending_events(event_type)
      search_results = GetIntoTeachingApiClient::TeachingEventsApi
                         .new
                         .search_teaching_events_grouped_by_type(
                           events_search_params(event_type),
                         )

      @group_presenter = Events::GroupPresenter.new(search_results)
      @events = @group_presenter.paginated_events_of_type(
        event_type,
        params[:page],
      )
    end

    def events_search_params(event_type)
      {
        type_id: event_type,
        status_ids: [pending_event_status_id],
        quantity_per_type: 1_000,
      }
    end

    def pending_event_status_id
      GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
    end

    def open_event_status_id
      GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"]
    end

    def event_types
      {
        provider: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        online: GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"],
      }
        .with_indifferent_access
        .freeze
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
        :type_id,
        :scribble_id,
      )
    end

    def building_params
      params.require(:internal_event).require(:building).permit(
        :id,
        :venue,
        :address_line1,
        :address_line2,
        :address_line3,
        :address_city,
        :address_postcode,
      )
    end
  end
end
