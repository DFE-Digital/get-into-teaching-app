class EventsController < ApplicationController
  before_action :load_events, :categorise_events, only: %i[index search]

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

private

  def load_events
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events
    @display_all_events_section = event_search_params[:type].blank?
  end

  def categorise_events
    hash_default_value_is_array = Hash.new { |h, k| h[k] = [] }

    @events_by_type = @events.each_with_object(hash_default_value_is_array) do |event, hash|
      hash[event.type_id] << event
    end

    return unless @display_all_events_section

    @events_by_type.transform_values! { |events| events.first(CATEGORISED_EVENTS_TO_DISPLAY) }
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth), type: "")

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
