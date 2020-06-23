class EventStepsController < ApplicationController
  include WizardSteps
  self.wizard_class = Events::Wizard

private

  def wizard_store
    Wizard::Store.new session_store
  end

  def session_store
    session[:events] ||= {}
    session[:events][params[:event_id]] ||= {}
  end
end
