require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::SubjectInterestedTeaching do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  it_behaves_like "with a wizard step that exposes API lookup items as options",
                  :get_teaching_subjects, described_class::OMIT_SUBJECT_IDS

  describe "attributes" do
    it { is_expected.to respond_to :preferred_teaching_subject_id }
  end

  describe "#preferred_teaching_subject_id" do
    it "allows a valid preferred_teaching_subject_id" do
      subject_item = GetIntoTeachingApiClient::TeachingSubject.new(id: "abc-123")
      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(:get_teaching_subjects) { [subject_item] }
      expect(subject).to allow_value(subject_item.id).for :preferred_teaching_subject_id
    end

    it { is_expected.not_to allow_values("", nil, "invalid-id").for :preferred_teaching_subject_id }
  end

  describe "#skipped?" do
    it "returns false if HaveADegree step was shown and preferred_education_phase_id is secondary" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:secondary]
      expect(subject).not_to be_skipped
    end

    it "returns false if HaveADegree step was shown and preferred_education_phase_id is secondary and have a degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:secondary]
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).not_to be_skipped
    end

    it "returns true if HaveADegree was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(true)
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:secondary]
      expect(subject).to be_skipped
    end

    it "returns true if education phase is primary" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["preferred_education_phase_id"] = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:primary]
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:subject_item) { GetIntoTeachingApiClient::TeachingSubject.new(id: "123", value: "Value") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::LookupItemsApi).to \
        receive(:get_teaching_subjects) { [subject_item] }
      instance.preferred_teaching_subject_id = subject_item.id
    end

    it { is_expected.to eq({ "preferred_teaching_subject_id" => "Value" }) }
  end
end
