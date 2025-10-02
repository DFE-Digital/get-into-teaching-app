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
    it "skipped if degree status was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "skipped if not studying or does not have a degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(false)
      expect(subject).to be_skipped
    end

    it "skipped if has an equivalent degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(true)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeCountry).to receive(:another_country?).and_return(true)
      expect(subject).to be_skipped
    end

    it "not skipped if degree status step was shown and is studying" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(true)
      expect(subject).not_to be_skipped
    end

    it "not skipped if degree status step was shown and has a degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(true)
      expect(subject).not_to be_skipped
    end
  end
end
