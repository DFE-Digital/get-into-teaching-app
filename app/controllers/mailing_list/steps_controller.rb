module MailingList
  class StepsController < ApplicationController
    include WizardSteps
    self.wizard_class = MailingList::Wizard

    before_action :set_page_title, except: %i[index completed resend_verification]

  private

    def step_path(step = params[:id])
      mailing_list_step_path step
    end
    helper_method :step_path

    def wizard_store
      ::Wizard::Store.new session_store
    end

    def session_store
      session[:mailinglist] ||= {}
    end

    def set_page_title
      @page_title = "Sign up for personalised updates, #{@current_step.title.downcase} step"
    end
  end
end
