require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::StartTeacherTraining do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :initial_teacher_training_year_id }
  end

  describe "#initial_teacher_training_year_id" do
    it "allows a valid initial_teacher_training_year_id" do
      year = GetIntoTeachingApiClient::PickListItem.new(id: 12_917)
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_candidate_initial_teacher_training_years) { [year] }
      expect(subject).to allow_value(12_917).for :initial_teacher_training_year_id
    end

    it { is_expected.not_to allow_values("", nil, 456).for :initial_teacher_training_year_id }
  end

  describe "#years" do
    before do
      years = [
        GetIntoTeachingApiClient::PickListItem.new(id: 12_917, value: "Not sure"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_920, value: "2022"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_921, value: "2023"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_922, value: "2024"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_923, value: "2025"),
      ]

      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_candidate_initial_teacher_training_years) { years }
    end

    let(:years) { subject.years }

    context "when its before 24th June of the current year (2022)" do
      around do |example|
        travel_to(Date.new(2022, 6, 23)) { example.run }
      end

      it "returns 'Not sure', and the current year plus next 2 years" do
        expect(years.map(&:value)).to contain_exactly(
          "Not sure",
          "2022 - start your training this September",
          "2023",
          "2024",
        )
      end
    end

    context "when its 24th June of the current year (2022)" do
      around do |example|
        travel_to(Date.new(2022, 6, 24)) { example.run }
      end

      it "returns 'Not sure', and the current year plus next 3 years" do
        expect(years.map(&:value)).to contain_exactly(
          "Not sure",
          "2022 - start your training this September",
          "2023",
          "2024",
          "2025",
        )
      end
    end

    context "when its between 24th June and 3th September of the current year (2022)" do
      around do |example|
        travel_to(Date.new(2022, 9, 3)) { example.run }
      end

      it "returns 'Not sure', and the current year plus next 2 years" do
        expect(years.map(&:value)).to contain_exactly(
          "Not sure",
          "2022 - start your training this September",
          "2023",
          "2024",
          "2025",
        )
      end
    end

    context "when its after 17th September of the current year (2022)" do
      around do |example|
        travel_to(Date.new(2022, 9, 17)) { example.run }
      end

      it "returns 'Not sure', and the next 3 years" do
        expect(years.map(&:value)).to contain_exactly(
          "Not sure",
          "2023 - start your training next September",
          "2024",
          "2025",
        )
      end
    end

    context "when its 1st January of the current year (2023)" do
      around do |example|
        travel_to(Date.new(2023, 1, 1)) { example.run }
      end

      it "returns 'Not sure', and the next 3 years" do
        expect(years.map(&:value)).to contain_exactly(
          "Not sure",
          "2023 - start your training this September",
          "2024",
          "2025",
        )
      end
    end
  end

  describe "#skipped?" do
    it "returns false if DegreeStatus step was shown and degree_option is not studying" do
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

    it "returns true if degree_option is studying (not final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(true)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::StageOfDegree).to receive(:final_year?).and_return(false)
      expect(subject).to be_skipped
    end
  end

  describe "inferred_year_id" do
    before do
      years = [
        GetIntoTeachingApiClient::PickListItem.new(id: 12_917, value: "Not sure"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_920, value: "2022"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_921, value: "2023"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_922, value: "2024"),
        GetIntoTeachingApiClient::PickListItem.new(id: 12_923, value: "2025"),
      ]

      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_candidate_initial_teacher_training_years) { years }

      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_in_progress?).and_return(true)
    end

    it "returns current calendar year + 2 years if degree stage is 'first year', and date is before 17th September" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:first_year]
      travel_to(Date.new(2022, 9, 16)) do
        expect(instance.inferred_year_id).to eq(12_922)
      end
    end

    it "returns current calendar year + 3 years if degree stage is 'first year', and date is on or after 17th September" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:first_year]
      travel_to(Date.new(2022, 9, 17)) do
        expect(instance.inferred_year_id).to eq(12_923)
      end
    end

    it "returns current calendar year + 1 year if degree stage is 'second year', and date is before 17th September" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:second_year]
      travel_to(Date.new(2022, 9, 16)) do
        expect(instance.inferred_year_id).to eq(12_921)
      end
    end

    it "returns current calendar year + 2 years if degree stage is 'second year', and date is on or after 17th September" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:second_year]
      travel_to(Date.new(2022, 9, 17)) do
        expect(instance.inferred_year_id).to eq(12_922)
      end
    end

    it "returns current calendar year + 1 year if degree stage is 'other', and date is before 17th September" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:other]
      travel_to(Date.new(2022, 9, 16)) do
        expect(instance.inferred_year_id).to eq(12_921)
      end
    end

    it "returns current calendar year + 2 years if degree stage is 'other', and date is on or after 17th September" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:other]
      travel_to(Date.new(2022, 9, 17)) do
        expect(instance.inferred_year_id).to eq(12_922)
      end
    end

    it "returns nil if final year" do
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:final_year]
      travel_to(Date.new(2022, 9, 17)) do
        expect(instance.inferred_year_id).to be_nil
      end
    end

    it "returns nil if not studying" do
      wizardstore["degree_option"] = TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_OPTION_YES
      wizardstore["degree_status_id"] = TeacherTrainingAdviser::Steps::StageOfDegree::NOT_FINAL_YEAR[:first_year]
      travel_to(Date.new(2022, 9, 17)) do
        expect(instance.inferred_year_id).to be_nil
      end
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    let(:pick_list_item) { GetIntoTeachingApiClient::PickListItem.new(id: 12_917, value: "Value") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_candidate_initial_teacher_training_years) { [pick_list_item] }
      instance.initial_teacher_training_year_id = pick_list_item.id
    end

    it { is_expected.to eq({ "initial_teacher_training_year_id" => "Value" }) }

    context "when initial_teacher_training_year_id is nil" do
      before { instance.initial_teacher_training_year_id = nil }

      it { is_expected.to eq({ "initial_teacher_training_year_id" => nil }) }
    end
  end
end
