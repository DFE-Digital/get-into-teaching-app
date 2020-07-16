require "rails_helper"

describe Events::Steps::FurtherDetails do
  include_context "wizard step"

  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :privacy_policy }
    it { is_expected.to respond_to :future_events }
    it { is_expected.to respond_to :address_postcode }
  end

  context "validations" do
    it { is_expected.to allow_value("1").for :privacy_policy }
    it { is_expected.not_to allow_value("0").for :privacy_policy }
    it { is_expected.not_to allow_value("").for :privacy_policy }

    it { is_expected.to allow_value("1").for :future_events }
    it { is_expected.to allow_value("0").for :future_events }
    it { is_expected.not_to allow_value("").for :future_events }

    it { is_expected.to allow_value("TE571NG").for :address_postcode }
    it { is_expected.to allow_value("TE57 1NG").for :address_postcode }
    it { is_expected.to allow_value(" TE57 1NG ").for :address_postcode }
    it { is_expected.to allow_value("").for :address_postcode }
    it { is_expected.not_to allow_value("unknown").for :address_postcode }
  end

  context "data cleaning" do
    let(:attributes) { { address_postcode: "  TE57 1NG " } }
    before { subject.valid? }
    it { is_expected.to have_attributes address_postcode: "TE57 1NG" }
  end
end
