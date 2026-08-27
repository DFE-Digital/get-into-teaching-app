require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::StageInterestedTeaching do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_skipped }

  describe "attributes" do
    it { is_expected.to respond_to :preferred_education_phase_id }
  end

  describe "#preferred_education_phase_id" do
    it { is_expected.not_to allow_values("", nil, 123).for :preferred_education_phase_id }
    it { is_expected.to allow_value(*TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS.values).for :preferred_education_phase_id }
  end

  describe "#skipped?" do
    before do
      allow_any_instance_of(TeacherTrainingAdviser::Steps::DegreeCountry).to receive(:another_country?).and_return(another_country)
    end

    context "when not another country" do
      let(:another_country) { false }

      it { is_expected.not_to be_skipped }
    end

    context "when another country" do
      let(:another_country) { true }

      it { is_expected.to be_skipped }
    end
  end

  describe "#interested_in_primary?" do
    before do
      instance.preferred_education_phase_id = preferred_education_phase_id
    end

    subject { instance.interested_in_primary? }

    context "when primary" do
      let(:preferred_education_phase_id) { 222_750_000 }

      it { is_expected.to be true }
    end

    context "when secondary" do
      let(:preferred_education_phase_id) { 222_750_001 }

      it { is_expected.to be false }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.preferred_education_phase_id = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:primary] }

    it { is_expected.to eq({ "preferred_education_phase_id" => "Primary" }) }
  end
end
