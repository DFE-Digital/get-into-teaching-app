module Callbacks
  class StepsController < ApplicationController
    include CircuitBreaker

    include GITWizard::Controller
    self.wizard_class = Callbacks::Wizard

    before_action :noindex
    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]
    before_action :check_expired_session
    around_action :set_time_zone, only: %i[show update]

    layout "registration"

    def not_available
      render "not_available"
    end

    def completed_step_path
      phone_call_scheduled_at = @wizard.find("callback").phone_call_scheduled_at.in_time_zone(Time.zone)
      date = phone_call_scheduled_at.to_date.to_formatted_s(:govuk)
      time = phone_call_scheduled_at.to_formatted_s(:govuk_time_with_period)

      step_path :completed, date: date, time: time
    end

  protected

    def not_available_path
      callbacks_not_available_path
    end

  private

    def set_time_zone
      old_time_zone = Time.zone
      Time.zone = "London"

      yield
    ensure
      Time.zone = old_time_zone
    end

    def step_path(step = params[:id], urlparams = {})
      callbacks_step_path step, urlparams
    end
    helper_method :step_path

    def wizard_store
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:callbacks] = if session[:callbacks].nil?
                              session[:mailinglist]&.slice("first_name", "last_name", "email", "accepted_policy_id") || {}
                            else
                              session[:callbacks].merge(session[:mailinglist]&.slice("first_name", "last_name", "email", "accepted_policy_id"))
                            end
    end

    def crm_store
      session[:callbacks_crm] ||= {}
    end

    def set_step_page_title
      @page_title = "Book a callback"
      unless @current_step.nil?
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "Callback confirmed"
    end

    def check_expired_session
      redirect_to session_expired_path if session[:mailinglist].blank?
    end
  end
end
