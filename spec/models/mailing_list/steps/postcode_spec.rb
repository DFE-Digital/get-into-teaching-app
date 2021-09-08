require "rails_helper"

describe MailingList::Steps::Postcode do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  let(:msg) { "Enter a valid postcode" }

  it { is_expected.to respond_to :address_postcode }
  it { expect(subject).to be_optional }

  describe "validations for address_postcode" do
    it { is_expected.to allow_value("TE57 1NG").for :address_postcode }
    it { is_expected.to allow_value("  TE571NG  ").for :address_postcode }
    it { is_expected.to allow_value(nil).for :address_postcode }
    it { is_expected.to allow_value("").for :address_postcode }
    it { is_expected.not_to allow_value("random").for(:address_postcode).with_message(msg) }
    it { is_expected.not_to allow_value("TE57 ING").for(:address_postcode).with_message(msg) }
  end

  describe "data cleaning for the postcode" do
    it "normalises the postcode" do
      subject.address_postcode = "  te57 1ng "
      subject.valid?
      expect(subject.address_postcode).to eq("TE57 1NG")
      subject.address_postcode = "  "
      subject.valid?
      expect(subject.address_postcode).to be_nil
    end
  end
end
