class EventsController < ApplicationController
  def index
    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    @events = api.get_upcoming_teaching_events
    @event_search = Events::Search.new
    categories = ["Train to Teach events", "Online events"]
    @events_by_category = categories.map do |category|
      events = 5.times.collect do
        {
          category: category,
          title: "Train to teach Coventry Online event",
          datetime: "11 May 2020 at 17:00 - 18:30",
          description: "This online event specifically for anybody looking to train to teach in Coventry will give you the opportunity to ask our experts questions about teacher training.",
          type: GetIntoTeachingApi::Constants::EVENT_TYPES["Train to Teach Event"],
          online: true,
          location: "Coventry",
          readable_id: "ttc-online-event",
        }
      end
      { category_name: category, events: events }
    end
  end

  def search
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events

    render "index"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
  rescue GetIntoTeachingApiClient::ApiError
    render template: "errors/not_found", status: :not_found
  end

private

  def event_search_params
    params
      .require(Events::Search.model_name.param_key)
      .permit(:type, :distance, :postcode, :month)
  end
end
