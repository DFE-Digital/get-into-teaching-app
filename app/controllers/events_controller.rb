class EventsController < ApplicationController
  before_action :load_events, only: %i[index search]
  before_action :categorise_events, only: %i[index]

  CATEGORISED_EVENTS_TO_DISPLAY = 3

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

    render template: "errors/not_found", status: :not_found if @type.nil?

    @event_search = Events::Search.new(type: @type.id)
    @events = @event_search.query_events
  end

private

  def load_events
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events
  end

  def categorise_events
    hash_default_value_is_array = Hash.new { |h, k| h[k] = [] }

    @events_by_type = @events.each_with_object(hash_default_value_is_array) do |event, hash|
      hash[event.type_id] << event
    end

    @events_by_type.transform_values! { |events| events.first(CATEGORISED_EVENTS_TO_DISPLAY) }
  end

  def event_search_params
    defaults = ActionController::Parameters.new(
      month: Time.zone.today.to_formatted_s(:yearmonth),
      type: "",
    )

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
