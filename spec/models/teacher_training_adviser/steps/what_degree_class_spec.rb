require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::WhatDegreeClass do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"
  it_behaves_like "a wizard step that exposes API pick list items as options",
                  :get_qualification_uk_degree_grades, described_class::OMIT_GRADE_IDS

  describe "attributes" do
    it { is_expected.to respond_to :uk_degree_grade_id }
  end

  describe "#uk_degree_grade_id" do
    it "allows a valid uk_degree_grade_id" do
      grade = GetIntoTeachingApiClient::PickListItem.new(id: described_class.options["Not applicable"])
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_qualification_uk_degree_grades) { [grade] }
      expect(subject).to allow_value(grade.id).for :uk_degree_grade_id
    end

    it { is_expected.not_to allow_values("", nil, 456).for :uk_degree_grade_id }
  end

  describe "#skipped?" do
    it "returns false if DegreeStatus step was shown and degree_option is yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(true)
      expect(subject).not_to be_skipped
    end

    it "returns false if DegreeStatus step was shown and degree_option is studying (final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(true)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::StageOfDegree).to receive(:final_year?).and_return(true)
      expect(subject).not_to be_skipped
    end

    it "returns true if DegreeStatus was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(true)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:has_degree?).and_return(true)
      expect(subject).to be_skipped
    end

    it "returns true if degree_option is not yes" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      # TODO: add test for equivalent degree
      # wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end

    it "returns true if degree_option is studying (not final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(true)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::StageOfDegree).to receive(:final_year?).and_return(false)
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:pick_list_item) { GetIntoTeachingApiClient::PickListItem.new(id: 123, value: "Value") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_qualification_uk_degree_grades) { [pick_list_item] }
      instance.uk_degree_grade_id = pick_list_item.id
    end

    it { is_expected.to eq({ "uk_degree_grade_id" => "Value" }) }
  end
end
