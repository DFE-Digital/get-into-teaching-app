module TeacherTrainingAdviser
  class StepsController < ApplicationController
    include CircuitBreaker
    include GITWizard::Controller
    self.wizard_class = TeacherTrainingAdviser::Wizard

    around_action :set_time_zone, only: %i[show update]
    before_action :check_feature_switch
    before_action :set_step_page_title, only: %i[show update]
    before_action :set_completed_page_title, only: [:completed]
    before_action :noindex, unless: -> { request.path.include?("/#{first_step_class.key}") }
    layout :resolve_layout

    def completed
      super

      @returner = wizard_store[:type_id].to_i == Steps::ReturningTeacher::OPTIONS[:returning_to_teaching]
      @equivalent = wizard_store[:degree_options] == Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      @callback_booked = wizard_store[:callback_offered] && @equivalent
      @first_name = wizard_store[:first_name]
    end

  protected

    def not_available_path
      teacher_training_adviser_not_available_path
    end

  private

    def resolve_layout
      is_first_page = @current_step.instance_of?(first_step_class)

      return "registration_with_side_images" if is_first_page

      "registration"
    end

    def first_step_class
      wizard_class.steps.first
    end

    def check_feature_switch
      raise_not_found unless ActiveModel::Type::Boolean.new.cast(ENV["GET_AN_ADVISER"])
    end

    def set_time_zone
      old_time_zone = Time.zone
      Time.zone = @wizard.time_zone
      yield
    ensure
      Time.zone = old_time_zone
    end

    def step_path(step = params[:id], params = {})
      teacher_training_adviser_step_path step, params
    end
    helper_method :step_path

    def wizard_store
      ::GITWizard::Store.new app_store, crm_store
    end

    def app_store
      session[:sign_up] ||= {}
    end

    def crm_store
      session[:sign_up_crm] ||= {}
    end

    def set_step_page_title
      @page_title = "Get an adviser"

      if @current_step&.title
        @page_title += ", #{@current_step.title.downcase} step"
      end
    end

    def set_completed_page_title
      @page_title = "You've signed up"
    end
  end
end
