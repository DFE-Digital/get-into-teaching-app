class EventsController < ApplicationController
  before_action :load_events, only: %i[index search]
  before_action :categorise_events, only: %i[index]

  EVENTS_PER_CATEGORY = 3

  def index
    # Events are loaded in a before_action
  end

  def search
    render "index"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
  rescue GetIntoTeachingApiClient::ApiError
    render template: "errors/not_found", status: :not_found
  end

  def show_category
    @type = GetIntoTeachingApiClient::TypesApi.new.get_teaching_event_types.find do |type|
      type.value.parameterize == params[:category]
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
    @events_by_category = events_sorted_by_type.each_with_object({}) do |event, hash|
      type_id = event.type_id
      category_name = event_category_name(type_id)
      type_name = event_type_name(type_id)

      hash[category_name] ||= {}
      hash[category_name][type_name] ||= []

      next if hash[category_name][type_name].count == EVENTS_PER_CATEGORY

      hash[category_name][type_name] << event
    end
  end

  def events_sorted_by_type
    @events.sort_by do |event|
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.values.index(event.type_id)
    end
  end

  def event_category_name(type_id)
    get_into_teaching_type_ids = GetIntoTeachingApiClient::Constants::GET_INTO_TEACHING_EVENT_TYPES.values
    return "Get into Teaching" if get_into_teaching_type_ids.include?(type_id)

    event_type_name(type_id)
  end

  def event_type_name(type_id)
    api = GetIntoTeachingApiClient::TypesApi.new
    type = api.get_teaching_event_types.find { |t| t.id == type_id.to_s }
    type&.value || ""
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
