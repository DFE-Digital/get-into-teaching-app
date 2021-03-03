class EventCategoriesController < ApplicationController
  include CircuitBreaker
  before_action :load_type
  before_action :set_form_action
  layout "events"

  breadcrumb "events.search", :events_path

  EVENTS_PER_PAGE = 9
  MAXIMUM_EVENTS_IN_CATEGORY = 1_000

  def show
    @show_archive_link = has_archive?(@type)

    @category_name = helpers.pluralised_category_name(@type.id)
    @page_title = @category_name

    load_events(:future)
  end

  def show_archive
    raise_not_found unless has_archive?(@type)

    @category_name = helpers.past_category_name(@type.id)
    @page_title = @category_name

    load_events(:past)

    future_events_category_name = helpers.pluralised_category_name(@type.id)
    breadcrumb \
      future_events_category_name,
      event_category_path(future_events_category_name.parameterize)

    render :show
  end

protected

  def not_available_path
    events_not_available_path
  end

private

  def load_events(period)
    @event_search = Events::Search.new(event_filter_params.merge(type: @type.id, period: period))
    events_by_type = @event_search.query_events(MAXIMUM_EVENTS_IN_CATEGORY)
    group_presenter = Events::GroupPresenter.new(events_by_type, false, @event_search.future?)
    events_of_type = group_presenter.sorted_events_of_type(@type.id)
    @events = paginate(events_of_type)
  end

  def load_type
    @type = GetIntoTeachingApiClient::PickListItemsApi.new.get_teaching_event_types.find do |type|
      I18n.t("event_types.#{type.id}.name.plural").parameterize == params[:id]
    end

    raise_not_found if @type.nil?
  end

  def set_form_action
    @form_action = URI.parse(request.path)
    @form_action.fragment = "searchforevents"
  end

  def paginate(events)
    return [] if events.blank?

    Kaminari
      .paginate_array(events, total_count: events&.size)
      .page(params[:page])
      .per(EVENTS_PER_PAGE)
  end

  def has_archive?(type)
    GetIntoTeachingApiClient::Constants::EVENT_TYPES_WITH_ARCHIVE.values.include?(type.id)
  end

  # filtering is like searching but limited to a single event type. A custom
  # type isn't required and a month isn't enforced
  def event_filter_params
    return {} unless (event_params = params[Events::Search.model_name.param_key])

    event_params.permit(:distance, :postcode, :month)
  end
end
