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
    it "skipped if DegreeStatus was skipped" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(true)
      expect(subject).to be_skipped
    end

    it "skipped if degree status is studying (not final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:studying_not_final_year?).and_return(true)
      expect(subject).to be_skipped
    end

    it "not skipped if DegreeStatus step was shown and studying (in final year)" do
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:skipped?).and_return(false)
      expect_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:studying_not_final_year?).and_return(false)
      expect(subject).not_to be_skipped
    end
  end

  describe "inferred_year_id" do
    before do
      years = [
        GetIntoTeachingApiClient::PickListItem.new(id: 0, value: "Not sure"),
        GetIntoTeachingApiClient::PickListItem.new(id: 2025, value: "2025"),
        GetIntoTeachingApiClient::PickListItem.new(id: 2026, value: "2026"),
        GetIntoTeachingApiClient::PickListItem.new(id: 2027, value: "2027"),
        GetIntoTeachingApiClient::PickListItem.new(id: 2028, value: "2028"),
      ]

      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_candidate_initial_teacher_training_years) { years }

      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:degree_status_id).and_return(degree_status_id)
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeStatus).to receive(:graduation_year).and_return(graduation_year)
    end

    around do |example|
      travel_to(test_date) do
        example.run
      end
    end

    context "when in first year of study" do
      let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_IN_PROGRESS }

      context "when the date is after graduation_cutoff (31 August) and before date_to_drop_current_year (17 September) (start of academic year)" do
        let(:test_date) { Date.new(2025, 9, 16) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to eql(graduation_year) }
      end

      context "when the date is after graduation_cutoff (31 August) and after date_to_drop_current_year (17 September) (start of academic year)" do
        let(:test_date) { Date.new(2025, 9, 18) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to eql(graduation_year) }
      end

      context "when the date is on or before graduation_cutoff (31 August) and before date_to_drop_current_year (17 September) (end of academic year)" do
        let(:test_date) { Date.new(2026, 8, 31) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to eql(graduation_year) }
      end
    end

    context "when in second year of study" do
      let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_IN_PROGRESS }

      context "when the date is after graduation_cutoff (31 August) and before date_to_drop_current_year (17 September) (start of academic year)" do
        let(:test_date) { Date.new(2026, 9, 16) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to eql(graduation_year) }
      end

      context "when the date is after graduation_cutoff (31 August) and after date_to_drop_current_year (17 September) (start of academic year)" do
        let(:test_date) { Date.new(2026, 9, 18) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to eql(graduation_year) }
      end

      context "when the date is on or before graduation_cutoff (31 August) and before date_to_drop_current_year (17 September) (end of academic year)" do
        let(:test_date) { Date.new(2027, 8, 31) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to eql(graduation_year) }
      end
    end

    context "when in final year of study" do
      let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::DEGREE_IN_PROGRESS }

      context "when the date is after graduation_cutoff (31 August) and before date_to_drop_current_year (17 September) (start of academic year)" do
        let(:test_date) { Date.new(2027, 9, 16) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to be_nil }
      end

      context "when the date is after graduation_cutoff (31 August) and after date_to_drop_current_year (17 September) (start of academic year)" do
        let(:test_date) { Date.new(2027, 9, 18) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to be_nil }
      end

      context "when the date is on or before graduation_cutoff (31 August) and before date_to_drop_current_year (17 September) (end of academic year)" do
        let(:test_date) { Date.new(2028, 8, 31) }
        let(:graduation_year) { 2028 }

        it { expect(instance.inferred_year_id).to be_nil }
      end
    end

    context "when not studying (HAS_DEGREE)" do
      let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::HAS_DEGREE }
      let(:graduation_year) { nil }
      let(:test_date) { Time.zone.today }

      it { expect(instance.inferred_year_id).to be_nil }
    end

    context "when not studying (NO_DEGREE)" do
      let(:degree_status_id) { TeacherTrainingAdviser::Steps::DegreeStatus::NO_DEGREE }
      let(:graduation_year) { nil }
      let(:test_date) { Time.zone.today }

      it { expect(instance.inferred_year_id).to be_nil }
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
