require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::RetakeGcseScience do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :planning_to_retake_gcse_science_id }
  end

  describe "planning_to_retake_gcse_science_id" do
    it { is_expected.not_to allow_values(nil, 123).for :planning_to_retake_gcse_science_id }
    it { is_expected.to allow_values(*TeacherTrainingAdviser::Steps::RetakeGcseScience::OPTIONS.values).for :planning_to_retake_gcse_science_id }
  end

  describe "#skipped?" do
    it "returns false if GcseScience step was shown and has_gcse_science_id is no" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::GcseScience).to receive(:skipped?).and_return(false)
      wizardstore["has_gcse_science_id"] = TeacherTrainingAdviser::Steps::GcseScience::OPTIONS["No"]
      expect(subject).not_to be_skipped
    end

    it "returns true if GcseScience was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::GcseScience).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if has_gcse_science_id is not no" do
      wizardstore["has_gcse_science_id"] = nil
      expect(subject).to be_skipped
      wizardstore["has_gcse_science_id"] = TeacherTrainingAdviser::Steps::GcseScience::OPTIONS["Yes"]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.planning_to_retake_gcse_science_id = Crm::BooleanType::ALL["Yes"] }

    it { is_expected.to eq({ "planning_to_retake_gcse_science_id" => "Yes" }) }
  end
end
