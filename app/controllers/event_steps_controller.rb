class EventStepsController < ApplicationController
  before_action :load_event
  before_action :redirect_closed_events, only: %i[show update] # rubocop:disable Rails/LexicallyScopedActionFilter

  include WizardSteps
  self.wizard_class = Events::Wizard

private

  def redirect_closed_events
    return unless @event.status_id == GetIntoTeachingApiClient::Constants::EVENT_STATUS["Closed"]

    redirect_to event_path(id: @event.readable_id)
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
    Wizard::Store.new session_store
  end

  def session_store
    session[:events] ||= {}
    session[:events][params[:event_id]] ||= {}
  end

  def load_event
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:event_id])
  end

  def set_page_title
    @page_title = "Sign up for #{@event.name}"
    unless @current_step.nil?
      @page_title += ", #{@current_step.title.downcase} step"
    end
  end
end
