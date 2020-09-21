module MailingList
  class StepsController < ApplicationController
    include WizardSteps
    self.wizard_class = MailingList::Wizard

    before_action :set_page_title, only: [:show] # rubocop:disable Rails/LexicallyScopedActionFilter

  private

    def step_path(step = params[:id], urlparams = {})
      mailing_list_step_path step, urlparams
    end
    helper_method :step_path

    def wizard_store
      ::Wizard::Store.new session_store
    end

    def session_store
      session[:mailinglist] ||= {}
    end

    def set_page_title
      @page_title = "Sign up for personalised updates"
      unless @current_step.nil?
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end
  end
end
