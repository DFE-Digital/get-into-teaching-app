class EventCategoriesController < ApplicationController
  include CircuitBreaker
  before_action :load_type
  before_action :set_form_action
  layout "events"

  breadcrumb "events.search", :events_path

  MAXIMUM_EVENTS_IN_CATEGORY = 1_000

  def show
    @show_archive_link = has_archive?(@type)

    @category_name = helpers.pluralised_category_name(@type.id)
    @page_title = @category_name
    @front_matter = {
      "description" => "Get your questions answered at a #{@category_name} event.",
      "title" => @category_name,
      "image" => "media/images/content/hero-images/0015.jpg",
    }

    load_events(:future)
  end

  def show_archive
    raise_not_found unless has_archive?(@type)

    @category_name = helpers.past_category_name(@type.id)

    @page_title = @category_name
    @front_matter = {
      "description" => "See past #{@category_name} events.",
      "title" => @category_name,
      "image" => "media/images/content/hero-images/0015.jpg",
    }

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
    group_presenter = Events::GroupPresenter.new(
      events_by_type,
      display_empty: false,
      ascending: @event_search.future?,
    )
    @events = group_presenter.paginated_events_of_type(@type.id, params[:page]) || []
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
