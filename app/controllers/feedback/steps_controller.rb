module Feedback
  class StepsController < ApplicationController
    include CircuitBreaker

    include GITWizard::Controller
    self.wizard_class = Feedback::Wizard

    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]

    layout "registration"

    def not_available
      render "not_available"
    end

  private

    def first_step_class
      wizard_class.steps.first
    end

    def set_time_zone
      old_time_zone = Time.zone
      Time.zone = @wizard.time_zone
      yield
    ensure
      Time.zone = old_time_zone
    end

    def step_path(step = params[:id], params = {})
      feedback_step_path step, params
    end
    helper_method :step_path

    def wizard_store
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:feedback] ||= {}
    end

    def crm_store
      session[:feedback_crm] ||= {}
    end

    def set_step_page_title
      @page_title = "Feedback"

      if @current_step&.title
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "Thank you for your feedback"
    end
  end
end
