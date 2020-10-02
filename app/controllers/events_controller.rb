class EventsController < ApplicationController
  before_action :load_events, only: %i[index search]
  before_action :categorise_events, only: %i[index search]

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

    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    @events = api.search_teaching_events(type_id: @type.id)
  end

private

  def load_events
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events
  end

  def categorise_events
    @events_by_group = events_sorted_by_category.each_with_object({}) do |event, hash|
      type_id = event.type_id
      group_key = event_group_key(type_id)

      hash[group_key] ||= {}
      hash[group_key][type_id] ||= []

      hash[group_key][type_id] << event
    end
  end

  def events_sorted_by_category
    @events.sort_by do |event|
      [
        GetIntoTeachingApiClient::Constants::EVENT_TYPES.values.index(event.type_id),
        event.start_at,
      ]
    end
  end

  def event_group_key(type_id)
    get_into_teaching_type_ids = GetIntoTeachingApiClient::Constants::GET_INTO_TEACHING_EVENT_TYPES.values
    return "get_into_teaching" if get_into_teaching_type_ids.include?(type_id)

    type_id
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
