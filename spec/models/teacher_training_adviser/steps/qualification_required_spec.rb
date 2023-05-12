require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::QualificationRequired do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    it "returns false if RetakeGcseMathsEnglish was shown and they selected no" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish).to receive(:skipped?).and_return(false)
      wizardstore["planning_to_retake_gcse_maths_and_english_id"] = TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish::OPTIONS["No"]
      expect(subject).not_to be_skipped
    end

    it "returns false if RetakeGcseScience was shown and they selected no" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::RetakeGcseScience).to receive(:skipped?).and_return(false)
      wizardstore["planning_to_retake_gcse_science_id"] = TeacherTrainingAdviser::Steps::RetakeGcseScience::OPTIONS["No"]
      expect(subject).not_to be_skipped
    end

    it "returns true if RetakeGcseMathsEnglish was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if RetakeGcseMathsEnglish was shown and they selected yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish).to receive(:skipped?).and_return(false)
      wizardstore["planning_to_retake_gcse_maths_and_english_id"] = TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish::OPTIONS["Yes"]
      expect(subject).to be_skipped
    end

    it "returns true if RetakeGcseScience was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::RetakeGcseScience).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if RetakeGcseScience was shown and they selected yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::RetakeGcseScience).to receive(:skipped?).and_return(false)
      wizardstore["planning_to_retake_gcse_science_id"] = TeacherTrainingAdviser::Steps::RetakeGcseScience::OPTIONS["Yes"]
      expect(subject).to be_skipped
    end
  end
end
