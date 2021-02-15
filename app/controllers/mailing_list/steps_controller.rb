module MailingList
  class StepsController < ApplicationController
    include WizardSteps
    self.wizard_class = MailingList::Wizard

    before_action :set_step_page_title, only: [:show]
    before_action :set_completed_page_title, only: [:completed]

  private

    def step_path(step = params[:id], urlparams = {})
      mailing_list_step_path step, urlparams
    end
    helper_method :step_path

    def wizard_store
      ::Wizard::Stores::Combined.new app_store, crm_store
    end

    def app_store
      session[:mailinglist] ||= {}
    end

    def crm_store
      session[:mailinglist_crm] ||= {}
    end

    def set_step_page_title
      @page_title = "Get personalised information and updates about getting into teaching"
      unless @current_step.nil?
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "You've signed up"
    end
  end
end
