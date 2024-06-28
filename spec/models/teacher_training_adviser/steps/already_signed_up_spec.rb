require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::AlreadySignedUp do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    it "returns false if can_subscribe_to_teacher_training_adviser is false" do
      wizardstore["can_subscribe_to_teacher_training_adviser"] = false
      expect(subject).not_to be_skipped
    end

    it "returns true if can_subscribe_to_teacher_training_adviser is true/nil/undefined" do
      expect(subject).to be_skipped
      wizardstore["can_subscribe_to_teacher_training_adviser"] = nil
      expect(subject).to be_skipped
      wizardstore["can_subscribe_to_teacher_training_adviser"] = true
      expect(subject).to be_skipped
    end
  end
end
