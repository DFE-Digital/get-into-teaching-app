require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::WhatSubjectDegree do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :degree_subject }
  end

  describe "#degree_subject" do
    it { is_expected.not_to allow_values("", nil).for :degree_subject }
    it { is_expected.to allow_value("Maths").for :degree_subject }
  end

  describe "#available_degree_subjects" do
    subject { instance.available_degree_subjects }

    it { is_expected.to eq(DfE::ReferenceData::Degrees::SUBJECTS.all) }
  end

  describe "#skipped?" do
    it "returns false if DegreeStatus step was shown and degree_option is studying" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_OPTION_STUDYING
      expect(subject).not_to be_skipped
    end

    it "returns false if DegreeStatus step was shown and degree_option is yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_OPTION_YES
      expect(subject).not_to be_skipped
    end

    it "returns true if DegreeStatus was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    # TODO: add test for equivalent degree
    # it "returns true if degree_option is not studying/yes" do
    #   wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_OPTIONS[:equivalent]
    #   expect(subject).to be_skipped
    # end
  end
end
