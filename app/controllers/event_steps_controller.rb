class EventStepsController < ApplicationController
  include CircuitBreaker
  include HashedEmails

  before_action :set_is_walk_in, only: %i[show update]
  before_action :load_event

  include GITWizard::Controller
  self.wizard_class = Events::Wizard

  before_action :noindex
  before_action :restrict_sign_ups, only: %i[show update completed]
  before_action :set_step_page_title, only: %i[show update]
  before_action :set_completed_page_title, only: %i[completed]

  layout :resolve_layout

  def completed
    super
    @first_name = wizard_store[:first_name]
    @hashed_email = wizard_store[:hashed_email] if hash_email_address?
    @authenticate = wizard_store[:authenticate]
  end

protected

  def not_available_path
    events_not_available_path
  end

private

  def restrict_sign_ups
    event_is_open_for_registration = Crm::EventStatus.new(@event).accepts_online_registration?
    candidate_is_walk_in = wizard_store[:is_walk_in]

    unless event_is_open_for_registration || candidate_is_walk_in
      # Redirecting to the main event page will either render
      # the event in a closed state or return a 410 (Gone).
      redirect_to event_path(id: @event.readable_id)
    end
  end

  def step_path(step = params[:id], urlparams = {})
    event_step_path params[:event_id], step, urlparams
  end
  helper_method :step_path

  def completed_step_path
    step_path :completed
  end

  def wizard_store
    ::GITWizard::Store.new app_store, crm_store
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
    @event = TeachingEvents::EventPresenter.new(retrieve_event)
  end

  def retrieve_event
    GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:event_id])
  end

  def set_step_page_title
    @page_title = "Sign up for #{@event.name}"
    unless @current_step.nil?
      @page_title += ", #{@current_step.title.downcase} step"
    end
  end

  def set_completed_page_title
    @page_title = "#{@event.name}, sign up completed"
  end

  def set_is_walk_in
    wizard_store[:is_walk_in] = true if params.key?(:walk_in)
  end

  def resolve_layout
    return "registration_with_image_above" if @current_step.instance_of?(Events::Steps::PersonalDetails)
    return "minimal" if action_name == "completed"

    "registration"
  end

  def set_breadcrumb
    breadcrumb @page_title, request.path
  end
end
