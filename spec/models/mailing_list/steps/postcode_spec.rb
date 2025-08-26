require "rails_helper"

describe MailingList::Steps::Postcode do
  include_context "with wizard step"
  let(:msg) { "Enter a valid UK postcode" }

  it_behaves_like "a with wizard step"

  it { expect(subject).to be_optional }
  it { is_expected.to respond_to :address_postcode }

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

  describe "skipped?" do
    before do
      allow(instance).to receive(:other_step).with(:citizenship) { instance_double(MailingList::Steps::Citizenship, uk_citizen?: uk_citizen) }
      allow(instance).to receive(:other_step).with(:location) { instance_double(MailingList::Steps::Location, inside_the_uk?: inside_the_uk) }
    end

    context "when a UK citizen" do
      let(:uk_citizen) { true }

      it "is not skipped when a UK citizen" do
        is_expected.not_to be_skipped
      end
    end

    context "when a non-UK citizen" do
      let(:uk_citizen) { false }

      context "when inside the UK" do
        let(:inside_the_uk) { true }

        it "is not skipped when inside the UK" do
          is_expected.not_to be_skipped
        end
      end

      context "when outside the UK" do
        let(:inside_the_uk) { false }

        it "is skipped when outside the UK" do
          is_expected.to be_skipped
        end
      end
    end
  end
end
