module Internal
  class EventsController < ::InternalController
    before_action :load_buildings, only: %i[new edit create]
    layout "internal"

    def index
      @no_results = load_pending_events.blank?
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
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:format])
      @event =  Event.initialize_with_api_event(api_event)
      if @event.approve
        redirect_to internal_events_path(success: true)
      else
        render action: :new
      end
    end

    def create
      @event = Event.new(event_params)
      @event.building = format_building(event_params)
      if @event.submit_pending
        redirect_to internal_events_path(success: :pending)
      else
        render action: :new
      end
    end

    def edit
      api_event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      @event = Event.initialize_with_api_event(api_event)
      if @event.building.nil?
        @event.venue_type = Event::VENUE_TYPES[:none]
        @event.building = EventBuilding.new
      else
        @event.venue_type = Event::VENUE_TYPES[:existing]
      end
      render :new
    end

  private

    def format_building(event_params)
      case event_params[:venue_type]
      when Event::VENUE_TYPES[:existing]
        building = @buildings.select { |b| b.id == event_params[:building][:id] }
        transform_event_building(building.first&.to_hash)
      when Event::VENUE_TYPES[:add]
        building = event_params[:building].to_hash
        building[:id] = nil # Id may be present from previous selection
        EventBuilding.new(building)
      end
    end

    def transform_event_building(building)
      hash = building.transform_keys { |k| k.to_s.underscore }.filter { |k| EventBuilding.attribute_names.include?(k) }
      EventBuilding.new(hash)
    end

    def load_buildings
      @buildings = GetIntoTeachingApiClient::TeachingEventBuildingsApi
                     .new.get_teaching_event_buildings
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
          address_line_1
          address_line_2
          address_line_3
          address_city
          address_postcode
        ],
      )
    end

    def load_pending_events
      opts = {
        type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        status_ids: [pending_event_status_id],
        quantity_per_type: 1_000,
      }

      @events = GetIntoTeachingApiClient::TeachingEventsApi
                  .new
                  .search_teaching_events_grouped_by_type(opts)[0]&.teaching_events

      unless @events.nil?
        @events = Kaminari.paginate_array(@events).page(params[:page])
      end
    end

    def pending_event_status_id
      GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
    end
  end
end
