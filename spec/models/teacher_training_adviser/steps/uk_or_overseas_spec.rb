require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::UkOrOverseas do
  include_context "with a TTA wizard step"
  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :uk_or_overseas }
  end

  describe "#uk_or_overseas" do
    it { is_expected.not_to allow_value("").for :uk_or_overseas }
    it { is_expected.not_to allow_value(nil).for :uk_or_overseas }
    it { is_expected.not_to allow_value("Denmark").for :uk_or_overseas }
    it { is_expected.to allow_values(*described_class::OPTIONS.values).for :uk_or_overseas }
  end

  describe "#uk?" do
    it { is_expected.not_to be_uk }

    context "when UK has been selected" do
      before { instance.uk_or_overseas = described_class::OPTIONS[:uk] }

      it { is_expected.to be_uk }
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before { instance.uk_or_overseas = described_class::OPTIONS[:overseas] }

    it { is_expected.to eq({ "uk_or_overseas" => "Overseas" }) }
  end
end
