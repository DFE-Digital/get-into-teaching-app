require "rails_helper"

RSpec.describe "Review answers", type: :request do
  let(:model) { TeacherTrainingAdviser::Steps::ReviewAnswers }
  let(:step_path) { teacher_training_adviser_step_path model.key }

  context "when reviewing all steps without any steps being completed" do
    subject do
      TeacherTrainingAdviser::Wizard.steps.each do |step|
        allow_any_instance_of(step).to receive(:skipped?).and_return(false)
      end

      get step_path
      response
    end

    it { is_expected.to have_http_status :success }
  end
end
