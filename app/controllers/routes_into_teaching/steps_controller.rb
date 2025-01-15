module RoutesIntoTeaching
  class StepsController < ApplicationController
    include CircuitBreaker
    include GITWizard::Controller
    self.wizard_class = RoutesIntoTeaching::Wizard

    before_action :set_page_title
    before_action :set_step_page_title, only: %i[show update]
    before_action :noindex, if: :noindex?

    layout :resolve_layout

    def completed
      policy_id = params[:id]

      @privacy_policy = if policy_id
                          GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_privacy_policy(policy_id)
                        else
                          GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
                        end

      @results = RoutesIntoTeaching::Routes.recommended(session[:routes_into_teaching])

      breadcrumb @page_title, request.path
    end

    def completed
      @results = RoutesIntoTeaching::Routes.recommended(session[:routes_into_teaching])
    end

  private

    def noindex?
      # Only index the first step.
      !request.path.include?("/#{first_step_class.key}")
    end

    def first_step_class
      wizard_class.steps.first
    end

    def step_path(step = params[:id], params = {})
      routes_into_teaching_step_path step, params
    end

    helper_method :step_path

    def wizard_store
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:routes_into_teaching] ||= {}
    end

    def crm_store
      session[:routes_into_teaching] ||= {}
    end

    def set_page_title
      @page_title = "Find your route into teaching"
    end

    def set_step_page_title
      if @current_step&.title
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def resolve_layout
      action_name == "completed" ? "minimal" : "registration"
    end
  end
end
