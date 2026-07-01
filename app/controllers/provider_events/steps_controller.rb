module ProviderEvents
  class StepsController < ApplicationController
    include CircuitBreaker
    include GITWizard::Controller
    self.wizard_class = ProviderEvents::Wizard

    before_action :set_page_title
    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]
    before_action :noindex, except: %i[index]
    before_action :set_breadcrumb

    layout :resolve_layout

    def index
      # override inherited index method
    end

  private

    def first_step_class
      wizard_class.steps.first
    end

    def step_path(step = params[:id], params = {})
      provider_events_step_path step, params
    end

    helper_method :step_path

    def wizard_store
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:provider_events] ||= {}
    end

    def crm_store
      session[:provider_events] ||= {}
    end

    def set_page_title
      @page_title = "Provider Events"
    end

    def set_breadcrumb
      breadcrumb @page_title, request.path
    end

    def set_step_page_title
      if @current_step&.title
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "All done"
    end

    def resolve_layout
      %w[completed index].include?(action_name) ? "minimal" : "registration"
    end
  end
end
