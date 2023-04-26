require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::PreviousTeacherId do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.to be_optional }

  describe "attributes" do
    it { is_expected.to respond_to :teacher_id }
  end

  describe "#skipped?" do
    it "returns false if HasTeacherId was shown and they selected yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HasTeacherId).to receive(:skipped?).and_return(false)
      wizardstore["has_id"] = true
      expect(subject).not_to be_skipped
    end

    it "returns true if HasTeacherId was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HasTeacherId).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if has_id is false" do
      wizardstore["has_id"] = false
      expect(subject).to be_skipped
    end

    it "returns true when pre-filled with crm data" do
      wizardstore["has_id"] = true
      wizardstore.persist_preexisting({ "teacher_id" => "123456" })
      expect(subject).to be_skipped
    end
  end
end
