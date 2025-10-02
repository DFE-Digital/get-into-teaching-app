require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::Citizenship do
  include_context "with a TTA wizard step"
  include_context "with wizard data"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :citizenship }
  end

  describe "#citizenship" do
    it { is_expected.not_to allow_value("").for :citizenship }
    it { is_expected.not_to allow_value(nil).for :citizenship }
    it { is_expected.not_to allow_value("Denmark").for :citizenship }
    it { is_expected.to allow_values(described_class::UK_CITIZEN, described_class::NON_UK_CITIZEN).for :citizenship }
  end

  describe "#uk_citizen?" do
    it { is_expected.not_to be_uk_citizen }

    context "when UK has been selected" do
      before { instance.citizenship = described_class::UK_CITIZEN }

      it { is_expected.to be_uk_citizen }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.citizenship = described_class::NON_UK_CITIZEN }

    it { is_expected.to eq({ "citizenship" => "No" }) }
  end
end
