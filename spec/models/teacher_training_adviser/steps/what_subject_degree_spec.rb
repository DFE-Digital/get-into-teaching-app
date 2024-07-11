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

  describe "#options" do
    subject { described_class.options }

    it { is_expected.to eq(Crm::TeachingSubject.all_hash) }
  end

  describe "#skipped?" do
    it "returns false if HaveADegree step was shown and degree_options is studying" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying]
      expect(subject).not_to be_skipped
    end

    it "returns false if HaveADegree step was shown and degree_options is yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(false)
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:yes]
      expect(subject).not_to be_skipped
    end

    it "returns true if HaveADegree was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::HaveADegree).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if degree_options is not studying/yes" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end
  end

  describe "#autocomplete?" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("ADVISER_DEGREE_SUBJECT_AUTOCOMPLETE_ENABLED", false).and_return(adviser_degree_subject_autocomplete_flag)
    end

    context "when ADVISER_DEGREE_SUBJECT_AUTOCOMPLETE_ENABLED is not set" do
      let(:adviser_degree_subject_autocomplete_flag) { nil }

      it "returns false" do
        expect(subject).not_to be_autocomplete
      end
    end

    context "when ADVISER_DEGREE_SUBJECT_AUTOCOMPLETE_ENABLED=0" do
      let(:adviser_degree_subject_autocomplete_flag) { "0" }

      it "returns false" do
        expect(subject).not_to be_autocomplete
      end
    end

    context "when ADVISER_DEGREE_SUBJECT_AUTOCOMPLETE_ENABLED=1" do
      let(:adviser_degree_subject_autocomplete_flag) { "1" }

      it "returns true" do
        expect(subject).to be_autocomplete
      end
    end
  end
end
