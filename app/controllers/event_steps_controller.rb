class EventStepsController < ApplicationController
  before_action :load_event 

  include WizardSteps
  self.wizard_class = Events::Wizard

  before_action :set_page_title

private

  def step_path(step = params[:id])
    event_step_path params[:event_id], step
  end
  helper_method :step_path

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
    @page_title = "Sign up for #{@event.name}, #{@current_step.title.downcase} step"
  end
end
