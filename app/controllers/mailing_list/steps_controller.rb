module MailingList
  class StepsController < ApplicationController
    include CircuitBreaker
    include HashedEmails
    include GITWizard::Controller

    self.wizard_class = MailingList::Wizard

    before_action :noindex, unless: -> { request.path.include?("/name") }
    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]
    before_action :set_breadcrumb, only: [:completed]

    layout :resolve_layout

    def not_available
      render "not_available"
    end

    def completed
      super

      @first_name = wizard_store[:first_name]
      @degree_status_id = wizard_store[:degree_status_id]
      @inferred_degree_status = wizard_store[:inferred_degree_status]
      @degree_status_key = Crm::OptionSet.lookup_by_value(:degree_status, @degree_status_id) if @degree_status_id
      @hashed_email = wizard_store[:hashed_email] if hash_email_address?
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
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:mailinglist] ||= {}
    end

    def crm_store
      session[:mailinglist_crm] ||= {}
    end

    def resolve_layout
      is_first_page = @current_step.instance_of? MailingList::Steps::Name

      return "registration_with_side_images" if is_first_page
      return "minimal" if action_name == "completed"

      "registration"
    end

    def set_step_page_title
      if @current_step.present? && @current_step.title
        @page_title = @current_step.title

        unless @current_step.respond_to?(:skip_title_suffix?) && @current_step.skip_title_suffix?
          @page_title << " - Personalised guidance sign up"
        end
      else
        @page_title = "Personalised guidance sign up"
      end
    end

    def set_completed_page_title
      @page_title = "You're signed up for personalised guidance"
    end

    def set_breadcrumb
      breadcrumb @page_title, request.path
    end
  end
end
