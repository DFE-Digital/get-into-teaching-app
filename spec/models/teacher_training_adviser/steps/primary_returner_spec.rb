require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::PrimaryReturner do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    it "returns false if returning_to_teaching is true and preferred_education_phase_id is primary" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::ReturningTeacher).to receive(:returning_to_teaching).and_return(true)
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:primary]
      expect(subject).not_to be_skipped
    end

    it "returns true if returning_teacher is false" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::ReturningTeacher).to receive(:returning_to_teaching).and_return(false)
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:primary]
      expect(subject).to be_skipped
    end

    it "returns true if preferred_education_phase_id is not primary" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::ReturningTeacher).to receive(:returning_to_teaching).and_return(true)
      wizardstore["preferred_education_phase_id"] = "abc-123"
      expect(subject).to be_skipped
    end
  end
end
