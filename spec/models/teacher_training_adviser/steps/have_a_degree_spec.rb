require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::HaveADegree do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :degree_options }
    it { is_expected.to respond_to :degree_status_id }
    it { is_expected.to respond_to :degree_type_id }
  end

  describe "degree_options" do
    it { is_expected.not_to allow_values("random", "", nil).for :degree_options }
    it { is_expected.to allow_values(*TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS.values).for :degree_options }
  end

  describe "#degree_option=" do
    it "sets the correct degree_status_id/degree_type_id for value of degree" do
      subject.degree_options = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject.degree_status_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_STATUS_OPTIONS[:has_degree])
      expect(subject.degree_type_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_TYPE_OPTIONS[:has_degree])
    end

    it "sets the correct degree_status_id/degree_type_id when no" do
      subject.degree_options = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:no]
      expect(subject.degree_status_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_STATUS_OPTIONS[:no_degree])
      expect(subject.degree_type_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_TYPE_OPTIONS[:has_degree])
    end

    it "sets the correct degree_status_id/degree_type_id when studying" do
      subject.degree_options = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying]
      expect(subject.degree_status_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_STATUS_OPTIONS[:studying])
      expect(subject.degree_type_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_TYPE_OPTIONS[:has_degree])
    end

    it "sets the correct degree_status_id/degree_type_id when equivalent" do
      subject.degree_options = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject.degree_status_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_STATUS_OPTIONS[:has_degree])
      expect(subject.degree_type_id).to eq(TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_TYPE_OPTIONS[:has_degree_equivalent])
    end
  end

  describe "#skipped?" do
    it "returns false if returning_to_teaching is false" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::ReturningTeacher).to receive(:returning_to_teaching).and_return(false)
      expect(subject).not_to be_skipped
    end

    it "returns true if returning_to_teaching is true" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::ReturningTeacher).to receive(:returning_to_teaching).and_return(true)
      expect(subject).to be_skipped
    end
  end

  describe "#studying?" do
    context "when degree_options is not yet set" do
      before { wizardstore["degree_options"] = nil }

      it { is_expected.not_to be_studying }
    end

    context "when degree_options is studying" do
      before { wizardstore["degree_options"] = described_class::DEGREE_OPTIONS[:studying] }

      it { is_expected.to be_studying }
    end

    context "when degree_options is not studying" do
      before { wizardstore["degree_options"] = described_class::DEGREE_OPTIONS[:yes] }

      it { is_expected.not_to be_studying }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.degree_options = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying] }

    it { is_expected.to eq({ "degree_options" => "I'm studying for a degree" }) }

    context "when degree_options is nil" do
      before { instance.degree_options = nil }

      it { is_expected.to eq({ "degree_options" => nil }) }
    end
  end
end
