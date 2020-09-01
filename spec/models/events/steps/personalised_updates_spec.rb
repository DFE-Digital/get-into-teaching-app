require "rails_helper"

describe Events::Steps::PersonalisedUpdates do
  include_context "wizard step"

  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :address_postcode }
  end

  context "validations" do
    it { is_expected.to allow_value("TE571NG").for :address_postcode }
    it { is_expected.to allow_value("TE57 1NG").for :address_postcode }
    it { is_expected.to allow_value(" TE57 1NG ").for :address_postcode }
    it { is_expected.to allow_value("").for :address_postcode }
    it { is_expected.not_to allow_value("unknown").for :address_postcode }
  end

  context "data cleaning" do
    it "cleans the postcode" do
      subject.address_postcode = "  TE57 1NG "
      subject.valid?
      expect(subject.address_postcode).to eq("TE57 1NG")
      subject.address_postcode = "  "
      subject.valid?
      expect(subject.address_postcode).to be_nil
    end
  end

  context "skipped?" do
    let(:mailing_list) { nil }
    let(:backingstore) { { "subscribe_to_mailing_list" => mailing_list } }

    context "with mailing_list question not answered" do
      it { is_expected.to be_skipped }
    end

    context "with mailing_list question answered as yes" do
      let(:mailing_list) { true }
      it { is_expected.not_to be_skipped }
    end

    context "with mailing_list question answered as no" do
      let(:mailing_list) { false }
      it { is_expected.to be_skipped }
    end
  end
end
