module Internal
  class EventsController < ::InternalController
    layout "internal"
    before_action :load_pending_events, only: %i[index]

    def index
      @no_results = @events.blank?
    end

    def show
      @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
      raise_not_found unless @event.status_id == pending_event_status_id

      @page_title = @event.name
    end

  private

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
  end
end
