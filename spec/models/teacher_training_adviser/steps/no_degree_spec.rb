require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::NoDegree do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    before do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(degree_status_skipped)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_status_id).and_return(degree_status_id)
    end

    context "when DegreeStatus is not skipped" do
      let(:degree_status_skipped) { false }

      context "when the user selects NO_DEGREE" do
        let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::NO_DEGREE }

        it { is_expected.not_to be_skipped }
      end

      context "when the user selects DEGREE_IN_PROGRESS" do
        let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_IN_PROGRESS }

        it { is_expected.to be_skipped }
      end

      context "when the user selects HAS_DEGREE" do
        let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::HAS_DEGREE }

        it { is_expected.to be_skipped }
      end
    end

    context "when DegreeStatus is skipped" do
      let(:degree_status_skipped) { true }
      let(:degree_status_id) { nil }

      it { is_expected.to be_skipped }
    end
  end
end
