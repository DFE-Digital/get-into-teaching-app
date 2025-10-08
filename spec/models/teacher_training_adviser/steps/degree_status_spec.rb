require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::DegreeStatus do
  include_context "with a TTA wizard step"
  include_context "with wizard data"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :degree_status_id }
    it { is_expected.to respond_to :graduation_year }
  end

  describe "#skipped?" do
    before do
      allow_any_instance_of(TeacherTrainingAdviser::Steps::ReturningTeacher).to receive(:returning_to_teaching).and_return(returning_to_teaching)
    end

    context "when not a returning teacher" do
      let(:returning_to_teaching) { false }

      it { is_expected.not_to be_skipped }
    end

    context "when a returning teacher" do
      let(:returning_to_teaching) { true }

      it { is_expected.to be_skipped }
    end
  end

  describe "graduation_year" do
    before { instance.degree_status_id = described_class::DEGREE_IN_PROGRESS }

    it { is_expected.not_to allow_values(nil, "abcd", 1234, Time.current.year - 1, Time.current.year + 11).for :graduation_year }
    it { is_expected.to allow_values(Time.current.year + 1, Time.current.year + 9).for :graduation_year }
  end

  describe "degree_status_id" do
    it { is_expected.not_to allow_values("random", "", nil).for :degree_status_id }
    it { is_expected.to allow_values(222_750_000, 222_750_006, 222_750_004).for :degree_status_id }
  end

  describe "degree status helpers" do
    before { instance.degree_status_id = degree_status_id }

    context "when degree_status_id is unset" do
      let(:degree_status_id) { nil }

      it { is_expected.not_to be_has_degree }
      it { is_expected.not_to be_degree_in_progress }
      it { is_expected.not_to be_no_degree }
    end

    context "when degree_status_id is HAS_DEGREE" do
      let(:degree_status_id) { described_class::HAS_DEGREE }

      it { is_expected.to be_has_degree }
      it { is_expected.not_to be_degree_in_progress }
      it { is_expected.not_to be_no_degree }
    end

    context "when degree_status_id is DEGREE_IN_PROGRESS" do
      let(:degree_status_id) { described_class::DEGREE_IN_PROGRESS }

      it { is_expected.not_to be_has_degree }
      it { is_expected.to be_degree_in_progress }
      it { is_expected.not_to be_no_degree }
    end

    context "when degree_status_id is NO_DEGREE" do
      let(:degree_status_id) { described_class::NO_DEGREE }

      it { is_expected.not_to be_has_degree }
      it { is_expected.not_to be_degree_in_progress }
      it { is_expected.to be_no_degree }
    end
  end

  describe "studying helpers" do
    around do |example|
      travel_to(Date.new(2025, 1, 1)) { example.run }
    end

    before do
      instance.degree_status_id = described_class::DEGREE_IN_PROGRESS
      instance.graduation_year = graduation_year
    end

    context "when in first year of a 3-year degree" do
      let(:graduation_year) { 2027 }

      it { is_expected.to be_studying_first_year }
      it { is_expected.not_to be_studying_final_year }
      it { is_expected.to be_studying_not_final_year }
    end

    context "when in first year of a 6-year degree" do
      let(:graduation_year) { 2030 }

      it { is_expected.to be_studying_first_year }
      it { is_expected.not_to be_studying_final_year }
      it { is_expected.to be_studying_not_final_year }
    end

    context "when in penultimate year" do
      let(:graduation_year) { 2026 }

      it { is_expected.not_to be_studying_first_year }
      it { is_expected.not_to be_studying_final_year }
      it { is_expected.to be_studying_not_final_year }
    end

    context "when in final year" do
      let(:graduation_year) { 2025 }

      it { is_expected.not_to be_studying_first_year }
      it { is_expected.to be_studying_final_year }
      it { is_expected.not_to be_studying_not_final_year }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    context "when degree in progress" do
      before do
        instance.degree_status_id = described_class::DEGREE_IN_PROGRESS
        instance.graduation_year = 2025
      end

      it {
        is_expected.to eq({
          "degree_status_id" => "Not yet, I'm studying for one",
          "graduation_year" => 2025,
        })
      }
    end

    context "when degree_status_id is unset" do
      before { instance.degree_status_id = nil }

      it { is_expected.to eq({ "degree_status_id" => nil }) }
    end
  end
end
