require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::NoDegree do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    it "returns false if degree_option is no and HaveADegree step was shown" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTION_NO
      expect(subject).not_to be_skipped
    end

    it "returns true if degree_option is not no and HaveADegree step was shown" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTION_YES
      expect(subject).to be_skipped
    end

    it "returns true if HaveADegree step is skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(true)
      wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTION_NO
      expect(subject).to be_skipped
    end
  end
end
