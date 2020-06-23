require "rails_helper"

describe Events::Steps::FurtherDetails do
  include_context "wizard store"

  let(:instance) { described_class.new wizardstore }
  subject { instance }

  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :privacy_policy }
    it { is_expected.to respond_to :future_events }
    it { is_expected.to respond_to :postcode }
  end

  context "validations" do
    it { is_expected.to allow_value("1").for :privacy_policy }
    it { is_expected.not_to allow_value("0").for :privacy_policy }
    it { is_expected.not_to allow_value("").for :privacy_policy }

    it { is_expected.to allow_value("1").for :future_events }
    it { is_expected.to allow_value("0").for :future_events }
    it { is_expected.not_to allow_value("").for :future_events }

    it { is_expected.to allow_value("TE571NG").for :postcode }
    it { is_expected.to allow_value("TE57 1NG").for :postcode }
    it { is_expected.to allow_value(" TE57 1NG ").for :postcode }
    it { is_expected.to allow_value("").for :postcode }
    it { is_expected.not_to allow_value("unknown").for :postcode }
  end

  context "data cleaning" do
    subject { described_class.new wizardstore, postcode: "  TE57 1NG " }
    before { subject.valid? }
    it { is_expected.to have_attributes postcode: "TE57 1NG" }
  end
end
