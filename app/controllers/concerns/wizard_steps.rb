module WizardSteps
  extend ActiveSupport::Concern

  included do
    class_attribute :wizard_class
    before_action :load_current_step
  end

  def show; end

  def update
    @current_step.assign_attributes step_params

    if @current_step.save
      redirect_to next_step_path
    end
  end

private

  def wizard
    wizard_class.new(wizard_store, params[:id])
  end

  def load_current_step
    @current_step = wizard.find_current_step
  end

  def next_step_path
    next_step = wizard.next_step
    next_step ? event_step_path(next_step) : root_path
  end

  def step_params
    params.require(step_param_key).permit @current_step.attributes.keys
  end

  def step_param_key
    @current_step.class.model_name.param_key
  end
end
