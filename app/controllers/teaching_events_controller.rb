class TeachingEventsController < ApplicationController
  class EventNotViewableError < StandardError; end

  include CircuitBreaker

  before_action :setup_filter, only: :index

  rescue_from EventNotViewableError, with: :render_gone

  EVENT_COUNT = 15 # 15 regular ones per page

  def create
    encrypted_params = TeachingEvents::Search.new(search_params).encrypted_attributes
    redirect_to events_path({ teaching_events_search: encrypted_params })
  end

  def index
    @front_matter = {
      title: "Find an event near you or online",
      description: "Find out more about getting into teaching at a free event where you can get all your questions answered by teachers, advisers and training providers.",
      breadcrumbs: false,
    }.with_indifferent_access

    setup_results

    if @event_search.valid?
      all_events = @event_search.results.sort_by(&:start_at)
      @events = Kaminari.paginate_array(all_events).page(params[:page]).per(EVENT_COUNT)
    else
      @events = []

      render :index
    end
  end

  def show
    @event = TeachingEvents::EventPresenter.new(retrieve_event)

    breadcrumb "Events", events_path
    breadcrumb @event.name, request.path

    @front_matter = {
      title: @event.name,
      description: @event.summary,
    }.with_indifferent_access

    render layout: "teaching_event"
  end

  def not_available
    render "not_available"
  end

  def git_statistics
    # After 21/3/2026 there will be no further GIT events so this will always be zero
    respond_to do |format|
      format.json { render json: { open_events_count: 0 } }
    end
  end

private

  def not_available_path
    events_not_available_path
  end

  def retrieve_event
    GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id]).tap do |event|
      status = Crm::EventStatus.new(event)

      raise ActionController::RoutingError, "Not Found" if event.nil? || status.pending?
      raise(EventNotViewableError) unless status.viewable?
    end
  end

  def search_params
    params.permit(teaching_events_search: [:postcode, :distance, { online: [] }])[:teaching_events_search]
  end

  def setup_filter
    @distances = TeachingEvents::Search::DISTANCES
  end

  def setup_results
    @event_search = TeachingEvents::Search.new_decrypt(search_params)
  end

  def render_gone
    render("gone", status: :gone, layout: "content")
  end
end
