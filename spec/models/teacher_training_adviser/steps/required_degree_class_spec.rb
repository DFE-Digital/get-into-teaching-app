require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::RequiredDegreeClass do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    before do
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(degree_status_skipped)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:no_degree?).and_return(no_degree)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::WhatDegreeClass).to receive(:skipped?).and_return(what_degree_class_skipped)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::WhatDegreeClass).to receive(:degree_grade_2_2_or_above?).and_return(degree_grade_2_2_or_above)
    end

    let(:degree_status_skipped) { false }
    let(:no_degree) { false }
    let(:what_degree_class_skipped) { false }
    let(:degree_grade_2_2_or_above) { false }

    context "when DegreeStatus is skipped" do
      let(:degree_status_skipped) { true }

      it { is_expected.to be_skipped }
    end

    context "when no_degree?" do
      let(:no_degree) { true }

      it { is_expected.to be_skipped }
    end

    context "when WhatDegreeClass is skipped" do
      let(:what_degree_class_skipped) { true }

      it { is_expected.to be_skipped }
    end

    context "when degree_grade_2_2_or_above?" do
      let(:degree_grade_2_2_or_above) { true }

      it { is_expected.to be_skipped }
    end

    # otherwise it is not skipped
    it { is_expected.not_to be_skipped }
  end

  describe "#title_attribute" do
    subject { instance.title_attribute }

    before do
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(degree_in_progress)
    end

    context "when degree in progress" do
      let(:degree_in_progress) { true }

      it { is_expected.to be(:title_predicted) }
    end

    context "when degree not in progress" do
      let(:degree_in_progress) { false }

      it { is_expected.to be(:title_achieved) }
    end
  end
end
