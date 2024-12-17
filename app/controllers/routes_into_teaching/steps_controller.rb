module RoutesIntoTeaching
  class StepsController < ApplicationController
    include CircuitBreaker
    include GITWizard::Controller
    self.wizard_class = RoutesIntoTeaching::Wizard

    before_action :set_step_page_title, only: %i[show update]
    before_action :noindex, if: :noindex?

    layout :resolve_layout

    def completed
      @results = RoutesIntoTeaching::Routes.recommended(session[:routes_into_teaching])
    end

    def completed
      @yaml = YAML.load_file(Rails.root.join("config/values/routes_into_teaching.yml"))
      @answers = session[:routes_into_teaching]

      @results = @yaml["routes"].select do |route|
        next false if route["matches"].blank?

        route["matches"].all? do |match_rule|
          match_rule["answer"] == "*" ||
            match_rule["answer"] == @answers[match_rule["question"]]
        end
      end
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

    def set_step_page_title
      @page_title = "Routes into Teaching"

      if @current_step&.title
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def resolve_layout
      action_name == "completed" ? "minimal" : "registration"
    end
  end
end
