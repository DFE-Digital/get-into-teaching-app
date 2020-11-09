require "rails_helper"

describe StepsToBecomeATeacherController do
  describe "#show" do
    let(:template) { "testing/markdown_test" }

    before do
      allow_any_instance_of(described_class).to \
        receive(:steps_to_become_a_teacher_template).and_return template
    end

    subject do
      get "/steps-to-become-a-teacher"

      response
    end

    context "viewing steps-to-become-a-teacher" do
      it { is_expected.to have_http_status :success }
    end
  end
end
