class EventsController < ApplicationController
  before_action :load_event_search, only: %i[search index]
  before_action :search_events, only: %i[search]
  before_action :load_upcoming_events, only: %i[index]

  MAXIMUM_EVENTS_IN_CATEGORY = 1_000
  UPCOMING_EVENTS_PER_TYPE = 9
  EVENTS_PER_PAGE = 9

  def index
    @page_title = "Find an event near you"
  end

  def search
    @page_title = "Find an event near you"
    render "index"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    @page_title = @event.name
  rescue GetIntoTeachingApiClient::ApiError
    render template: "errors/not_found", status: :not_found
  end

  def show_category
    @type = GetIntoTeachingApiClient::TypesApi.new.get_teaching_event_types.find do |type|
      I18n.t("event_types.#{type.id}.name.plural").parameterize == params[:category]
    end

    render(template: "errors/not_found", status: :not_found) && return if @type.nil?

    @event_search = Events::Search.new(event_filter_params.merge(type: @type.id))
    all_results = @event_search.query_events(MAXIMUM_EVENTS_IN_CATEGORY)
    @events = paginate(all_results[@type.id.to_sym])
  end

private

  def paginate(events)
    return [] if events.blank?

    Kaminari
      .paginate_array(events, total_count: events&.size)
      .page(params[:page])
      .per(EVENTS_PER_PAGE)
  end

  def load_upcoming_events
    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    @events_by_type = api.upcoming_teaching_events_indexed_by_type(quantity_per_type: UPCOMING_EVENTS_PER_TYPE)
    @group_presenter = Events::GroupPresenter.new(@events_by_type)
  end

  def search_events
    @events_by_type = @event_search.query_events
    @display_empty_types = @event_search.type.nil?
    @group_presenter = Events::GroupPresenter.new(@events_by_type, @display_empty_types)
  end

  def load_event_search
    @event_search = Events::Search.new(event_search_params)
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end

  # filtering is like searching but limited to a single event type. A custom
  # type isn't required and a month isn't enforced
  def event_filter_params
    return {} unless (event_params = params[Events::Search.model_name.param_key])

    event_params.permit(:distance, :postcode, :month)
  end
end
