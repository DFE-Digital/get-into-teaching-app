require "rails_helper"

describe MailingList::Steps::Postcode do
  include_context "with wizard step"
  let(:msg) { "Enter a valid UK postcode" }

  it_behaves_like "a with wizard step"
  it_behaves_like "a normalised and validated postcode", :address_postcode, "Enter a valid UK postcode"

  it { expect(subject).to be_optional }

  it { is_expected.to allow_value(nil).for :address_postcode }
  it { is_expected.to allow_value("").for :address_postcode }

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
