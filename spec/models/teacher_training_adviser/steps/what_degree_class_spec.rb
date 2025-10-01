require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::WhatDegreeClass do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :uk_degree_grade_id }
  end

  describe "#uk_degree_grade_id" do
    let(:upper_second) { build(:degree_class, :upper_second) }
    it "allows a valid uk_degree_grade_id" do
      allow_any_instance_of(PickListItemsApiPresenter).to \
        receive(:get_qualification_uk_degree_grades) { [upper_second] }
      expect(subject).to allow_value(upper_second.id).for :uk_degree_grade_id
    end

    it { is_expected.not_to allow_values("", nil, 456).for :uk_degree_grade_id }
  end

  describe "#skipped?" do
    it "not skipped if DegreeStatus step was shown and they have a degree" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(true)
      expect(subject).not_to be_skipped
    end

    it "not skipped if DegreeStatus step was shown and they are studying (final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:studying_final_year?).and_return(true)
      expect(subject).not_to be_skipped
    end

    it "skipped if DegreeStatus was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "skipped if has a degree from another country" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeCountry).to receive(:another_country?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if degree_option is studying (not final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:studying_final_year?).and_return(false)
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:upper_second) { build(:degree_class, :upper_second) }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_qualification_uk_degree_grades) { [upper_second] }
      instance.uk_degree_grade_id = upper_second.id
    end

    it { is_expected.to eq({ "uk_degree_grade_id" => "Upper second-class honours (2:1)" }) }
  end
end
