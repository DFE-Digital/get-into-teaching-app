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
    accumulator = Hash.new { |h, k| h[k] = [] }

    @events_by_type = @events.each_with_object(accumulator) do |event, hash|
      hash[event.type_id] << event
    end

    @events_by_type.transform_values! { |events| events.first(EVENTS_PER_CATEGORY) }
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
