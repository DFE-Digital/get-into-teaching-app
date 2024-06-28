require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::GcseScience do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :has_gcse_science_id }
  end

  describe "has_gcse_science_id" do
    it { is_expected.not_to allow_values(nil, 123).for :has_gcse_science_id }
    it { is_expected.to allow_values(*TeacherTrainingAdviser::Steps::GcseScience::OPTIONS.values).for :has_gcse_science_id }
  end

  describe "#skipped?" do
    it "returns false if GcseMathsEnglish was shown, they have a GCSE maths/english and phase is primary" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::GcseMathsEnglish).to receive(:skipped?).and_return(false)
      wizardstore["has_gcse_maths_and_english_id"] = TeacherTrainingAdviser::Steps::GcseMathsEnglish::OPTIONS["Yes"]
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:primary]
      expect(subject).not_to be_skipped
    end

    it "returns true if GcseMathsEnglish was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::GcseMathsEnglish).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if they neither have or are planning to retake GCSE maths and english" do
      wizardstore["has_gcse_maths_and_english_id"] = TeacherTrainingAdviser::Steps::GcseMathsEnglish::OPTIONS["No"]
      wizardstore["planning_to_retake_gcse_maths_and_english_id"] = TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish::OPTIONS["No"]
      expect(subject).to be_skipped
    end

    it "returns true if preferred_education_phase_id is secondary" do
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:secondary]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.has_gcse_science_id = Crm::BooleanType::ALL["Yes"] }

    it { is_expected.to eq({ "has_gcse_science_id" => "Yes" }) }
  end
end
