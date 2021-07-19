module MailingList
  class StepsController < ApplicationController
    include CircuitBreaker

    include WizardSteps
    self.wizard_class = MailingList::Wizard

    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]

    layout :resolve_layout

    def not_available
      render "not_available"
    end

  protected

    def not_available_path
      mailinglist_not_available_path
    end

  private

    def step_path(step = params[:id], urlparams = {})
      mailing_list_step_path step, urlparams
    end
    helper_method :step_path

    def wizard_store
      ::Wizard::Store.new app_store, crm_store
    end

    def app_store
      session[:mailinglist] ||= {}
    end

    def crm_store
      session[:mailinglist_crm] ||= {}
    end

    def resolve_layout
      is_first_page = @current_step.instance_of? MailingList::Steps::Name

      return "registration_attractive" if is_first_page

      "registration"
    end

    def set_step_page_title
      @page_title = "Get personalised guidance to your inbox"
      unless @current_step.nil?
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "You've signed up"
    end
  end
end
