class EventStepsController < ApplicationController
  include CircuitBreaker

  before_action :set_is_walk_in, only: %i[show update]
  before_action :load_event

  include DFEWizard::Controller
  self.wizard_class = Events::Wizard

  before_action :noindex
  before_action :redirect_closed_events, only: %i[show update]
  before_action :set_step_page_title, only: [:show]
  before_action :set_completed_page_title, only: [:completed]

  layout :resolve_layout

protected

  def not_available_path
    events_not_available_path
  end

private

  def noindex
    @noindex = true
  end

  def redirect_closed_events
    event_is_closed = @event.status_id == GetIntoTeachingApiClient::Constants::EVENT_STATUS["Closed"]
    candidate_is_walk_in = wizard_store[:is_walk_in]

    if event_is_closed && !candidate_is_walk_in
      redirect_to event_path(id: @event.readable_id)
    end
  end

  def step_path(step = params[:id], urlparams = {})
    event_step_path params[:event_id], step, urlparams
  end
  helper_method :step_path

  def completed_step_path
    if wizard_store["subscribe_to_mailing_list"]
      step_path :completed, subscribed: 1
    else
      step_path :completed
    end
  end

  def wizard_store
    ::DFEWizard::Store.new app_store, crm_store
  end

  def app_store
    session[:events] ||= {}
    session[:events][params[:event_id]] ||= {}
  end

  def crm_store
    session[:events_crm] ||= {}
    session[:events_crm][params[:event_id]] ||= {}
  end

  def load_event
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:event_id])
  end

  def set_step_page_title
    @page_title = "Sign up for #{@event.name}"
    unless @current_step.nil?
      @page_title += ", #{@current_step.title.downcase} step"
    end
  end

  def set_completed_page_title
    @page_title = "Sign up complete"
  end

  def set_is_walk_in
    wizard_store[:is_walk_in] = true if params.key?(:walk_in)
  end

  def resolve_layout
    return "registration_with_image_above" if @current_step.instance_of?(Events::Steps::PersonalDetails)

    "registration"
  end
end
