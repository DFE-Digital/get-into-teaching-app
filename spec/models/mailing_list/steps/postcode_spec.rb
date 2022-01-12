require "rails_helper"

describe MailingList::Steps::Postcode do
  include_context "with wizard step"
  let(:msg) { "Enter a valid postcode" }

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :address_postcode }

  describe "validations for address_postcode" do
    it { is_expected.to allow_value("TE57 1NG").for :address_postcode }
    it { is_expected.to allow_value("  TE571NG  ").for :address_postcode }
    it { is_expected.to allow_value(nil).for :address_postcode }
    it { is_expected.to allow_value("").for :address_postcode }
    it { is_expected.not_to allow_value("random").for(:address_postcode).with_message(msg) }
    it { is_expected.not_to allow_value("TE57 ING").for(:address_postcode).with_message(msg) }

    context "when send_event_emails is true" do
      before { subject.send_event_emails = true }

      it { is_expected.not_to allow_value(nil).for(:address_postcode) }
    end
  end

  describe "validations for send_event_emails" do
    it { is_expected.not_to allow_value(nil).for(:send_event_emails) }
    it { is_expected.to validate_inclusion_of(:send_event_emails).in_array([true, false]) }
  end

  describe "#export" do
    subject { instance.export["address_postcode"] }

    let(:backingstore) { { "send_event_emails" => true, "address_postcode" => "app-postcode" } }
    let(:crm_backingstore) { {} }

    it { is_expected.to eq("app-postcode") }

    context "when the postcode exists in the CRM and they select 'No'" do
      let(:backingstore) { { "send_event_emails" => false } }
      let(:crm_backingstore) { { "address_postcode" => "crm-postcode" } }

      it { is_expected.to eq("crm-postcode") }
    end
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
