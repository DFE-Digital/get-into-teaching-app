module Internal
  class EventsController < ::InternalController
    layout "internal"
    before_action :authorize_publisher, only: %i[approve withdraw]
    helper_method :event_type_name

    EVENTS_PER_PAGE = 10
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
      raw_teaching_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])

      raise_not_found unless Crm::EventStatus.new(raw_teaching_event).pending?

      @event = TeachingEvents::EventPresenter.new(raw_teaching_event)

      @page_title = @event.name
    end

    def new
      if params[:duplicate]
        @event = get_event_by_id(params[:duplicate])
        @event.assign_attributes(NILIFY_ON_DUPLICATE.index_with { |_attribute| nil })
      else
        @event_type = determine_event_type_from_name(params[:event_type])
        @event = Event.new(venue_type: Event::VENUE_TYPES[:existing], type_id: @event_type)
        @event.building = EventBuilding.new
      end
    end

    def approve
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      api_event.status_id = Crm::EventStatus.open_id
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
      api_event.status_id = Crm::EventStatus.pending_id
      GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(api_event)
      Rails.logger.info("#{@user.username} - withdrawn - #{api_event.to_json}")
      redirect_to internal_events_path(
        status: :withdrawn,
        event_type: determine_event_type_from_id(api_event.type_id),
        readable_id: api_event.readable_id,
      )
    end

    def open_events
      @open_events = GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
        quantity: 1_000,
        start_after: Time.zone.now.utc.beginning_of_day,
        status_ids: [Crm::EventStatus.open_id],
        type_ids: [event_types[:provider], event_types[:online]],
      )
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
      api = GetIntoTeachingApiClient::TeachingEventsApi.new
      results = api.search_teaching_events(events_search_params(event_type))

      @events = Kaminari.paginate_array(results, total_count: results.count)
        .page(params[:page])
        .per(EVENTS_PER_PAGE)
    end

    def events_search_params(event_type)
      {
        type_ids: [event_type],
        status_ids: [Crm::EventStatus.pending_id],
        start_after: Time.zone.now.utc.beginning_of_day,
        quantity: 1_000,
      }
    end

    def event_types
      {
        provider: Crm::EventType.school_or_university_event_id,
        online: Crm::EventType.online_event_id,
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
